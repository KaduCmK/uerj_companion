import * as admin from "firebase-admin";
import { setGlobalOptions, firestore } from "firebase-functions/v2";
import { defineSecret } from "firebase-functions/params";
import { beforeUserCreated, HttpsError } from "firebase-functions/v2/identity";
import { googleAI } from "@genkit-ai/googleai";
import { genkit } from 'genkit';

setGlobalOptions({ maxInstances: 4 });
admin.initializeApp();

const geminiApiKey = defineSecret("GEMINI_API_KEY");

exports.beforeCreate = beforeUserCreated((event) => {
    const user = event.data;

    if (!user?.email || !user.email.endsWith("@graduacao.uerj.br")) {
        throw new HttpsError(
            "invalid-argument",
            "Apenas universitários da graduação são permitidos"
        )
    }
})

exports.avaliacaoDocente = firestore.onDocumentWritten(
    {
        document: 'docentes/{docenteId}/avaliacoes/{avaliacaoId}',
        secrets: [geminiApiKey]
    },
    async (event) => {
        const apiKey = geminiApiKey.value();
        console.info(apiKey);
        const ai = genkit({
            plugins: [googleAI({ apiKey: apiKey })],
            model: googleAI.model('gemini-2.5-flash', { temperature: 0.8 })
        })

        const { docenteId } = event.params;
        const docenteRef = admin.firestore().collection("docentes").doc(docenteId);
        const avaliacoesSnapshot = await docenteRef.collection("avaliacoes").get();

        if (avaliacoesSnapshot.empty) {
            console.log('Nenhuma avaliação encontrada para o docente', docenteId);
            await docenteRef.update({ mediaAvaliacoes: 0 });
            return null;
        }

        let somaDasNotas = 0;
        const comentarios: string[] = [];

        avaliacoesSnapshot.forEach(doc => {
            const data = doc.data();
            somaDasNotas += data.nota;
            if (data.comentario && data.comentario.trim() !== "") {
                comentarios.push(data.comentario);
            }
        });

        const numAvaliacoes = avaliacoesSnapshot.size;
        const media = somaDasNotas / numAvaliacoes;

        if (comentarios.length < 3) {
            await docenteRef.update({
                resumoIA: 'Ainda não há avaliações o suficiente para gerar um resumo',
                mediaAvaliacoes: media
            });
            return null;
        }

        const prompt = `
        Você é um assistente que analisa o desempenho de professores.
        Baseado na nota média e nos comentários a seguir, gere um resumo conciso (2 a 5 frases) e imparcial sobre os pontos fortes e os pontos ruins do docente.
        Não inclua a nota do docente no resumo.

        - Nota média: ${media} de 5
        - Número de Avaliações: ${numAvaliacoes}
        - Comentarios:
        ${comentarios.map(c => `- "${c}"`).join('\n')}

        Resumo:
    `;

        try {
            console.info(`Gerando resumo para docente ID ${docenteId}`);
            const response = await ai.generate(prompt);
            response.assertValid();
            console.log(`Resumo gerado para docente ID ${docenteId}`);
            console.log("response:")
            console.log(response);
            console.log("response custom:");
            console.log(response.custom)
            console.log("response text:");
            console.log(response.text)
            const resumo = response.text || "Não foi possível gerar um resumo";

            return await docenteRef.update({
                resumoIA: resumo.trim(),
                mediaAvaliacoes: media
            });
        } catch (error) {
            console.error(`Erro ao gerar resumo para docente ID ${docenteId}:`, error);
            return await docenteRef.update({ resumoIA: 'Não foi possivel gerar um resumo' });
        }
    })