import * as admin from "firebase-admin";
import { auth } from "firebase-functions/v1";
import { beforeUserCreated, HttpsError } from "firebase-functions/identity";
import { Timestamp } from "firebase-admin/firestore";
import { https } from "firebase-functions";

// Bloqueia a criação de usuarios que nao pertencem ao dominio de estudantes de graduacao da uerj
export const beforeCreate = beforeUserCreated((event) => {
    const user = event.data;

    if (!user?.email || !user.email.endsWith("@graduacao.uerj.br")) {
        throw new HttpsError(
            "invalid-argument",
            "Apenas universitários da graduação são permitidos"
        )
    }
})

// Cria o doc de usuario correspondente dentro do Firestore
export const createFirestoreUser = auth.user().onCreate((user) => {
    console.log("Novo usuario sendo cadastrado no Firestore");

    const db = admin.firestore();
    const userRef = db.collection("users").doc(user.uid);

    return userRef.set({
        nome: user.displayName,
        email: user.email,
        createdAt: Timestamp.now(),
        role: 'estudante'
    }, { merge: true });
})

export const updateUserAfterLinking = https.onCall(async (data, context) => {
    if (!data.auth) {
        throw new HttpsError('unauthenticated', 'Apenas usuários autenticados podem executar essa função.');
    }

    const email = data.data.email;
    const nome = data.data.nome;

    const user = await admin.auth().getUser(data.auth.uid);
    if (!user.email) {
        throw new HttpsError('failed-precondition', 'Email do usuário não encontrado.');
    }

    const dataToUpdate: { email: string, nome?: string } = {
        email: user.email ?? email,
    }
    if (user.displayName ?? nome) {
        dataToUpdate.nome = user.displayName ?? nome
    }

    const userRef = admin.firestore().collection('users').doc(user.uid);
    console.log(`Atualizando usuario ${user.uid} apos vinculacao de conta`)
    console.log(user)
    console.log(`${user.email} -> ${user.displayName}`)

    return userRef.set(dataToUpdate, { merge: true });
})