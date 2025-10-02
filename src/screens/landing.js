import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import Svg, { Path } from 'react-native-svg';

const Logo = () => (
  <Svg width="150" height="150" viewBox="0 0 90 90" fill="none">
    <Path d="M10 90 L10 70 L25 70 L25 90" stroke="#00C49A" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round"/>
    <Path d="M35 90 L35 50 L50 50 L50 90" stroke="#00C49A" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round"/>
    <Path d="M60 90 L60 30 L75 30 L75 90" stroke="#00C49A" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round"/>
    <Path d="M5 65 L35 35 L43 40 L70 10" stroke="#00C49A" strokeWidth="4"/>
    <Path d="M55 13 L70 10 L70 25" stroke="#00C49A" strokeWidth="4" />
  </Svg>
);

const LandingPage = ({ navigation }) => {
  return (
    <View style={styles.container}>
      <Logo />
      <Text style={styles.title}>FinWise</Text>
      <Text style={styles.subtitle}>Track. Save. Smile.</Text>
      <TouchableOpacity
        style={[styles.button, styles.loginButton]}
        onPress={() => navigation.navigate('Login')}
      >
        <Text style={styles.buttonText}>Log In</Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={[styles.button, styles.signupButton]}
        onPress={() => navigation.navigate('SignUp')}
      >
        <Text style={styles.buttonText}>Sign Up</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 50,
    fontWeight: 'bold',
    color: '#00C49A',
    marginTop: 20,
  },
  subtitle: {
    fontSize: 15,
    color: '#666',
    marginBottom: 40,
  },
  button: {
    width: 200,
    height: 50,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 25,
    marginBottom: 20,
  },
  loginButton: {
    backgroundColor: '#00C49A',
  },
  signupButton: {
    backgroundColor: '#EEE',
  },
  buttonText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#000',
  },
});

export default LandingPage;