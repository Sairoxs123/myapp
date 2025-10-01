import React, { useState, useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import auth from '@react-native-firebase/auth';
import { ActivityIndicator, View, StyleSheet } from 'react-native';
import { enableScreens } from 'react-native-screens';

// Import Screens
import OnboardingScreen from './screens/onboarding_screen';
import LandingPage from './screens/landing';
import LoginPage from './auth/login';
import SignUpPage from './auth/signup';
import HomePage from './screens/home'; // This is the Bottom Tab Navigator
import AddCategoryScreen from './screens/add_category_screen';
import CategoryDetailScreen from './screens/category_detail_screen';
import AddTransactionScreen from './screens/add_transaction_screen';

enableScreens(); // For performance optimization

const Stack = createStackNavigator();

const App = () => {
  const [initializing, setInitializing] = useState(true);
  const [user, setUser] = useState(null);

  // Handle user state changes
  function onAuthStateChanged(user) {
    setUser(user);
    if (initializing) {
      setInitializing(false);
    }
  }

  useEffect(() => {
    const subscriber = auth().onAuthStateChanged(onAuthStateChanged);
    return subscriber; // unsubscribe on unmount
  }, []);

  if (initializing) {
    return (
      <View style={styles.loaderContainer}>
        <ActivityIndicator size="large" color="#00C49A" />
      </View>
    );
  }

  return (
    <NavigationContainer>
      <Stack.Navigator
        initialRouteName={user ? 'Home' : 'Onboarding'}
        screenOptions={{
          headerShown: false,
        }}
      >
        {user ? (
          // User is signed in
          <>
            <Stack.Screen name="Home" component={HomePage} />
            <Stack.Screen
              name="AddCategory"
              component={AddCategoryScreen}
              options={{ headerShown: true, title: 'Add Category' }}
            />
            <Stack.Screen
              name="CategoryDetail"
              component={CategoryDetailScreen}
              options={({ route }) => ({
                headerShown: true,
                title: route.params.categoryName,
              })}
            />
            <Stack.Screen
              name="AddTransaction"
              component={AddTransactionScreen}
              options={{ headerShown: true, title: 'Add Expense' }}
            />
          </>
        ) : (
          // No user is signed in
          <>
            <Stack.Screen name="Onboarding" component={OnboardingScreen} />
            <Stack.Screen name="Landing" component={LandingPage} />
            <Stack.Screen name="Login" component={LoginPage} />
            <Stack.Screen name="SignUp" component={SignUpPage} />
          </>
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
};

const styles = StyleSheet.create({
    loaderContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    }
});

export default App;