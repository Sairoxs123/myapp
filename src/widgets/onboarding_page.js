import React from 'react';
import { View, Text, Image, StyleSheet } from 'react-native';

const OnboardingPage = ({ imagePath, title, description }) => {
  return (
    <View style={styles.container}>
      <Image source={imagePath} style={styles.image} />
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.description}>{description}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  image: {
    width: 300,
    height: 300,
    marginBottom: 40,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 15,
  },
  description: {
    fontSize: 18,
    color: 'grey',
    textAlign: 'center',
  },
});

export default OnboardingPage;