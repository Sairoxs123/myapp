import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  Dimensions,
  FlatList,
} from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Ionicons } from '@expo/vector-icons';
import { useFocusEffect } from '@react-navigation/native'; // To refresh data on screen focus

const { width } = Dimensions.get('window');

const BalanceAndExpenseRow = () => (
  <View style={styles.header}>
    <View style={styles.headerRow}>
      <Text style={styles.headerLabel}>Total Balance</Text>
      <Text style={styles.headerLabel}>Total Expense</Text>
    </View>
    <View style={styles.headerRow}>
      <Text style={styles.headerValue}>$7,783.00</Text>
      <Text style={styles.headerValue}>-$1,187.40</Text>
    </View>
    <View style={styles.progressBarContainer}>
        <View style={[styles.progressBar, { width: '30%' }]} />
    </View>
    <View style={styles.headerRow}>
        <Text style={styles.progressLabel}>30% Of Your Expenses, Looks GOOD.</Text>
        <Text style={styles.progressLabel}>$20,000.00</Text>
    </View>
  </View>
);

const CategoryTile = ({ iconName, label, onPress }) => (
  <TouchableOpacity onPress={onPress} style={styles.tile}>
    <Ionicons name={iconName} size={40} color="#94D3A2" />
    <Text style={styles.tileLabel}>{label}</Text>
  </TouchableOpacity>
);

const CategoriesScreen = ({ navigation }) => {
  const [categories, setCategories] = useState([]);

  const getCategories = async () => {
    const storedCategories = await AsyncStorage.getItem('categories');
    if (storedCategories) {
      setCategories(JSON.parse(storedCategories));
    }
  };

  // useFocusEffect to refresh categories when the screen comes into view
  useFocusEffect(
    React.useCallback(() => {
      getCategories();
    }, [])
  );


  const renderCategoryTile = ({ item }) => {
    if (item.isAddButton) {
      return (
        <CategoryTile
          iconName="add"
          label="More"
          onPress={() => navigation.navigate('AddCategory')}
        />
      );
    }
    return (
      <CategoryTile
        iconName={item.iconCodePoint} // Assuming iconCodePoint stores the icon name
        label={item.categoryName}
        onPress={() =>
          navigation.navigate('CategoryDetail', { categoryName: item.categoryName })
        }
      />
    );
  };

  return (
    <View style={styles.container}>
        <BalanceAndExpenseRow />
        <View style={styles.gridContainer}>
            <FlatList
                data={[...categories, { isAddButton: true }]}
                renderItem={renderCategoryTile}
                keyExtractor={(item, index) => item.id ? item.id.toString() : `add-${index}`}
                numColumns={3}
                contentContainerStyle={styles.grid}
            />
        </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#94D3A2',
  },
  header: {
    paddingHorizontal: 25,
    paddingTop: 20,
    paddingBottom: 70,
  },
  headerRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 8,
  },
  headerLabel: {
    fontSize: 16,
    color: 'white',
  },
  headerValue: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
  },
  progressBarContainer: {
    height: 10,
    backgroundColor: 'rgba(255, 255, 255, 0.5)',
    borderRadius: 10,
    marginTop: 16,
  },
  progressBar: {
      height: 10,
      backgroundColor: 'blue',
      borderRadius: 10,
  },
  progressLabel: {
      fontSize: 12,
      color: 'white',
      marginTop: 8,
  },
  gridContainer: {
    flex: 1,
    backgroundColor: 'white',
    borderTopLeftRadius: 40,
    borderTopRightRadius: 40,
    marginTop: -54,
    paddingTop: 25,
  },
  grid: {
    paddingHorizontal: 12.5,
  },
  tile: {
    flex: 1,
    margin: 8,
    height: width / 3 - 24, // Adjust size based on screen width
    backgroundColor: '#E8F5E9',
    borderRadius: 15,
    justifyContent: 'center',
    alignItems: 'center',
  },
  tileLabel: {
    marginTop: 8,
    fontSize: 14,
    fontWeight: 'bold',
    color: '#333',
  },
});

export default CategoriesScreen;