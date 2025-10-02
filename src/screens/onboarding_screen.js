import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Dimensions } from 'react-native';
import auth from '@react-native-firebase/auth';
import OnboardingPage from '../widgets/onboarding_page'; // Assuming this is the path

const { width } = Dimensions.get('window');

const onboardingData = [
  {
    imagePath: require('../../assets/onboarding_image_1.png'), // Local images need to be required
    title: 'Welcome to FinWise',
    description: 'Easily manage your expenses and track your spending.',
  },
  {
    imagePath: require('../../assets/onboarding_image_2.png'),
    title: 'Stay Organized',
    description: 'Categorize your transactions and gain insights into your habits.',
  },
];

const OnboardingScreen = ({ navigation }) => {
  const [currentPage, setCurrentPage] = useState(0);
  const scrollViewRef = useRef(null);

  const handleScroll = (event) => {
    const pageIndex = Math.round(event.nativeEvent.contentOffset.x / width);
    setCurrentPage(pageIndex);
  };

  const handleNextPress = () => {
    if (currentPage < onboardingData.length - 1) {
      scrollViewRef.current?.scrollTo({ x: width * (currentPage + 1), animated: true });
    } else {
      const user = auth().currentUser;
      if (user) {
        navigation.replace('Home');
      } else {
        navigation.replace('Landing');
      }
    }
  };

  const renderDots = () => {
    return (
      <View style={styles.dotsContainer}>
        {onboardingData.map((_, index) => (
          <View
            key={index}
            style={[
              styles.dot,
              currentPage === index ? styles.activeDot : styles.inactiveDot,
            ]}
          />
        ))}
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <ScrollView
        ref={scrollViewRef}
        horizontal
        pagingEnabled
        showsHorizontalScrollIndicator={false}
        onScroll={handleScroll}
        scrollEventThrottle={16}
      >
        {onboardingData.map((item, index) => (
          <View key={index} style={{ width }}>
            <OnboardingPage
              imagePath={item.imagePath}
              title={item.title}
              description={item.description}
            />
          </View>
        ))}
      </ScrollView>
      <View style={styles.bottomContainer}>
        {renderDots()}
        <TouchableOpacity style={styles.nextButton} onPress={handleNextPress}>
          <Text style={styles.nextButtonText}>
            {currentPage === onboardingData.length - 1 ? 'Get Started' : 'Next'}
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
  },
  bottomContainer: {
    position: 'absolute',
    bottom: 40,
    left: 0,
    right: 0,
    alignItems: 'center',
  },
  dotsContainer: {
    flexDirection: 'row',
    marginBottom: 20,
  },
  dot: {
    height: 10,
    borderRadius: 5,
    marginHorizontal: 5,
  },
  activeDot: {
    backgroundColor: 'blue',
    width: 25,
  },
  inactiveDot: {
    backgroundColor: 'grey',
    width: 10,
  },
  nextButton: {
    backgroundColor: 'blue',
    paddingVertical: 12,
    paddingHorizontal: 30,
    borderRadius: 25,
  },
  nextButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default OnboardingScreen;