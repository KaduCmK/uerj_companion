import * as admin from "firebase-admin";
import { setGlobalOptions, firestore } from "firebase-functions/v2";
import { beforeUserCreated, HttpsError } from "firebase-functions/v2/identity";

setGlobalOptions({ maxInstances: 4 });

admin.initializeApp();

exports.beforeCreate = beforeUserCreated((event) => {
    const user = event.data;

    if (!user?.email || !user.email.endsWith("@graduacao.uerj.br")) {
        throw new HttpsError(
            "invalid-argument",
            "Apenas universitários da graduação são permitidos"
        )
    }
})

exports.avaliacaoDocente = firestore.onDocumentWritten('docentes/{docenteId}/avaliacoes/{avaliacaoId}', async (event) => {
    const { docenteId } = event.params;
    const docenteRef = admin.firestore().collection("docentes").doc(docenteId);
    const avaliacoesSnapshot = await docenteRef.collection("avaliacoes").get();

    if (avaliacoesSnapshot.empty) {
        console.log('Nenhuma avaliação encontrada para o docente', docenteId);
        return docenteRef.update({ mediaAvaliacoes: 0 });
    }

    let somaDasNotas = 0;
    avaliacoesSnapshot.forEach(doc => {
        somaDasNotas += doc.data().nota;
    });

    const totalAvaliacoes = avaliacoesSnapshot.size;
    const media = somaDasNotas / totalAvaliacoes;

    console.log('Media das avaliacoes do docente', docenteId, media);
    return docenteRef.update({ mediaAvaliacoes: media });
})