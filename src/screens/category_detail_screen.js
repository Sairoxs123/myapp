import React, 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  Alert,
} from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Ionicons } from '@expo/vector-icons';
import { useFocusEffect } from '@react-navigation/native';
import auth from '@react-native-firebase/auth';

const months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

const Header = () => (
  <View style={styles.headerContainer}>
    <View style={styles.balanceRow}>
      <View>
        <Text style={styles.balanceLabel}>Total Balance</Text>
        <Text style={styles.balanceValue}>$7,783.00</Text>
      </View>
      <View style={{ alignItems: 'flex-end' }}>
        <Text style={styles.balanceLabel}>Total Expense</Text>
        <Text style={[styles.balanceValue, { color: 'red' }]}>-$1,187.40</Text>
      </View>
    </View>
    <View style={styles.progressContainer}>
      <View style={styles.progressBar} />
    </View>
    <View style={styles.progressLabelContainer}>
        <Text>30% Of Your Expenses, Looks Good.</Text>
        <Text>$20,000.00</Text>
    </View>
  </View>
);

const TransactionItem = ({ item }) => {
    const date = new Date(item.timestamp);
    const formattedDate = `${months[date.getMonth()]} ${date.getDate()}`;
    const amountColor = item.type === 'expense' ? 'red' : 'green';
    const sign = item.type === 'expense' ? '-' : '+';
    // A simple mapping from category to icon
    const iconName = item.category === 'Food' ? 'fast-food' : 'apps';

    return (
        <View style={styles.transactionItem}>
            <Ionicons name={iconName} size={24} color="black" style={styles.transactionIcon} />
            <View style={styles.transactionDetails}>
                <Text style={styles.transactionTitle}>{item.title}</Text>
                <Text style={styles.transactionDate}>{formattedDate}</Text>
            </View>
            <Text style={[styles.transactionAmount, { color: amountColor }]}>
            {`${sign}$${Math.abs(item.amount).toFixed(2)}`}
            </Text>
        </View>
    );
};


const CategoryDetailScreen = ({ route, navigation }) => {
  const { categoryName } = route.params;
  const [transactions, setTransactions] = React.useState([]);
  const [currentUser, setCurrentUser] = React.useState(null);


  useFocusEffect(
    React.useCallback(() => {
      const getData = async () => {
        const storedTransactions = await AsyncStorage.getItem('transactions');
        if (storedTransactions) {
          const allTransactions = JSON.parse(storedTransactions);
          const filtered = allTransactions.filter(
            (t) => t.category === categoryName
          );

          if (filtered.length > 0) {
            setTransactions(filtered);
          } else {
            Alert.alert(
              'No Transactions',
              "You haven't added any transactions for this category yet.",
              [{ text: 'OK', onPress: () => navigation.goBack() }]
            );
          }
        } else {
          Alert.alert(
            'No Transactions',
            "You haven't added any transactions for this category yet.",
            [{ text: 'OK', onPress: () => navigation.goBack() }]
          );
        }
      };

      const user = auth().currentUser;
      if (user) {
        setCurrentUser(user);
        getData();
      } else {
        console.log('User not logged in');
        // Optionally navigate to login screen
      }
    }, [categoryName, navigation])
  );


  return (
    <View style={styles.container}>
      <Header />
      <FlatList
        data={transactions}
        renderItem={({ item }) => <TransactionItem item={item} />}
        keyExtractor={(item) => item.id.toString()}
        style={styles.list}
      />
      <TouchableOpacity
        style={styles.addButton}
        onPress={() => navigation.navigate('AddTransaction', { categoryName })}
      >
        <Text style={styles.addButtonText}>Add Expenses</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#C8E6C9',
  },
  headerContainer: {
    padding: 16,
    backgroundColor: '#C8E6C9',
  },
  balanceRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  balanceLabel: {
    fontSize: 16,
    color: 'black',
  },
  balanceValue: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  progressContainer: {
    height: 10,
    backgroundColor: '#BDBDBD',
    borderRadius: 5,
    marginTop: 16,
  },
  progressBar: {
    height: 10,
    width: '30%', // example
    backgroundColor: 'green',
    borderRadius: 5,
  },
  progressLabelContainer: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      marginTop: 8
  },
  list: {
    flex: 1,
    backgroundColor: 'white',
  },
  transactionItem: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  transactionIcon: {
      marginRight: 16,
  },
  transactionDetails: {
      flex: 1,
  },
  transactionTitle: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  transactionDate: {
    fontSize: 14,
    color: 'grey',
  },
  transactionAmount: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  addButton: {
    backgroundColor: 'green',
    padding: 16,
    margin: 16,
    borderRadius: 8,
    alignItems: 'center',
  },
  addButtonText: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
  },
});

export default CategoryDetailScreen;