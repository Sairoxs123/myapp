import auth from '@react-native-firebase/auth';

class AuthService {
  constructor() {
    this.auth = auth;
  }

  // --- Authentication Methods ---

  logInWithEmailAndPassword = async (email, password) => {
    try {
      const userCredential = await this.auth().signInWithEmailAndPassword(email, password);
      return userCredential;
    } catch (error) {
      throw error;
    }
  };

  signUpWithEmailAndPassword = async (name, email, password) => {
    try {
      const userCredential = await this.auth().createUserWithEmailAndPassword(email, password);
      const user = userCredential.user;
      await user.updateProfile({ displayName: name });
      await user.sendEmailVerification();
      return userCredential;
    } catch (error) {
      throw error;
    }
  };

  signOut = async () => {
    try {
      await this.auth().signOut();
    } catch (error) {
      throw error;
    }
  };

  // --- Auth State Listener ---

  onAuthStateChanged = (callback) => {
    return this.auth().onAuthStateChanged(callback);
  };
}

export default new AuthService();