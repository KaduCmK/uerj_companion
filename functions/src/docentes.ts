// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
// import {VertexAI, GenerativeModel} from "@google-cloud/vertexai";

// admin.initializeApp();

// // Initialize Vertex AI
// const vertexAI = new VertexAI({project: process.env.GCLOUD_PROJECT!, location: "us-central1"});
// const model = "gemini-1.5-flash-001";

// const generativeModel = vertexAI.getGenerativeModel({
//   model: model,
//   generationConfig: {
//     "maxOutputTokens": 2048,
//     "temperature": 1,
//     "topP": 1,
//   },
// });


// exports.onAvaliacaoCreate = functions.regions("southamerica-east1").firestore
//     .document("docentes/{docenteId}/avaliacoes/{avaliacaoId}")
//     .onCreate(async (snap, context) => {
//       const docenteId = context.params.docenteId;
//       const docenteRef = admin.firestore().collection("docentes").doc(docenteId);

//       // 1. Recalcular a média
//       const avaliacoesSnap = await docenteRef.collection("avaliacoes").get();
//       const avaliacoes = avaliacoesSnap.docs.map((doc) => doc.data());
//       const totalNotas = avaliacoes.reduce((acc, curr) => acc + curr.nota, 0);
//       const media = totalNotas / avaliacoes.length;

//       await docenteRef.update({mediaAvaliacoes: media});

//       // 2. Gerar resumo com Gemini
//       const comentarios = avaliacoes
//           .map((a) => a.comentario)
//           .filter((c) => c)
//           .join("\n - ");

//       if (comentarios.length > 3) { // Só gera resumo se tiver texto suficiente
//         try {
//           const prompt = `Resuma os seguintes comentários sobre um professor, destacando pontos positivos e negativos, em um parágrafo conciso: \n - ${comentarios}`;

//           const req = {
//             contents: [{role: "user", parts: [{text: prompt}]}],
//           };

//           const result = await generativeModel.generateContent(req);
//           const response = result.response;
//           const resumo = response.candidates[0].content.parts[0].text;


//           await docenteRef.update({resumoIA: resumo});
//         } catch (e) {
//           console.error("Erro ao gerar resumo com Gemini:", e);
//           // Opcional: atualiza o doc com uma msg de erro
//           await docenteRef.update({resumoIA: "Erro ao gerar resumo."});
//         }
//       }
//     });