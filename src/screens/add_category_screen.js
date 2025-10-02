import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, StyleSheet, TouchableOpacity, Alert } from 'react-native';
import firestore from '@react-native-firebase/firestore';
import auth from '@react-native-firebase/auth';
import { Ionicons } from '@expo/vector-icons'; // Assuming usage of Expo icons
import AsyncStorage from '@react-native-async-storage/async-storage';
import CategoriesModel from '../models/categories_model';

const iconOptions = [
  'fast-food',
  'cart',
  'home',
  'car',
  'medical',
  'gift',
  'wallet',
  'film',
  'ellipsis-horizontal',
];

const AddCategoryScreen = ({ navigation }) => {
  const [name, setName] = useState('');
  const [selectedIcon, setSelectedIcon] = useState(null);
  const [currentUser, setCurrentUser] = useState(null);

  useEffect(() => {
    const subscriber = auth().onAuthStateChanged(setCurrentUser);
    return subscriber; // unsubscribe on unmount
  }, []);

  const saveCategory = async () => {
    if (!currentUser?.uid) {
      Alert.alert('Error', 'You must be logged in to add a category.');
      return;
    }

    if (!name.trim() || !selectedIcon) {
      Alert.alert('Error', 'Please enter a name and select an icon.');
      return;
    }

    try {
      const newCategory = new CategoriesModel({
        categoryName: name.trim(),
        iconCodePoint: selectedIcon, // In RN, we can just store the name
      });

      // Save to Firestore
      await firestore()
        .collection('users')
        .doc(currentUser.uid)
        .collection('categories')
        .add({
          categoryName: newCategory.categoryName,
          iconName: newCategory.iconCodePoint, // Storing icon name instead of codepoint
        });

      // Save to local storage (AsyncStorage as an equivalent for Isar)
      const existingCategories = await AsyncStorage.getItem('categories');
      const categories = existingCategories ? JSON.parse(existingCategories) : [];
      categories.push(newCategory);
      await AsyncStorage.setItem('categories', JSON.stringify(categories));


      Alert.alert('Success', 'Category added successfully!', [
        { text: 'OK', onPress: () => navigation.goBack() },
      ]);
    } catch (error) {
      Alert.alert('Error', 'Failed to save category. Please try again.');
      console.error(error);
    }
  };

  return (
    <View style={styles.container}>
      <TextInput
        style={styles.input}
        placeholder="Category Name"
        value={name}
        onChangeText={setName}
      />
      <Text style={styles.iconSelectionTitle}>Select Icon:</Text>
      <View style={styles.iconContainer}>
        {iconOptions.map((iconName) => (
          <TouchableOpacity
            key={iconName}
            style={[
              styles.iconChip,
              selectedIcon === iconName && styles.selectedIconChip,
            ]}
            onPress={() => setSelectedIcon(iconName)}
          >
            <Ionicons name={iconName} size={32} color={selectedIcon === iconName ? 'white' : 'black'} />
          </TouchableOpacity>
        ))}
      </View>
      <TouchableOpacity style={styles.saveButton} onPress={saveCategory}>
        <Text style={styles.saveButtonText}>Save</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#fff',
  },
  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
    marginBottom: 24,
  },
  iconSelectionTitle: {
    fontSize: 16,
    marginBottom: 8,
  },
  iconContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-around',
  },
  iconChip: {
    padding: 12,
    borderRadius: 50,
    borderWidth: 1,
    borderColor: '#ddd',
    backgroundColor: '#f0f0f0',
    margin: 8,
  },
  selectedIconChip: {
    backgroundColor: '#66BB6A',
    borderColor: '#66BB6A',
  },
  saveButton: {
    backgroundColor: '#66BB6A',
    padding: 16,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 32,
  },
  saveButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
});

export default AddCategoryScreen;