/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions";
import {beforeUserCreated, HttpsError} from "firebase-functions/identity";

setGlobalOptions({ maxInstances: 4 });

exports.beforeCreate = beforeUserCreated((event) => {
    const user = event.data;

    if (!user?.email || !user.email.endsWith("@graduacao.uerj.br")) {
        throw new HttpsError(
            "invalid-argument",
            "Apenas universitários da graduação são permitidos"
        )
    }
})

export * from './docentes';