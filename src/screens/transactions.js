import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  FlatList,
  Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useFocusEffect } from '@react-navigation/native';

const months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

const BalanceCard = () => (
  <View style={styles.balanceCard}>
    <Text style={styles.balanceTitle}>Total Balance</Text>
    <Text style={styles.balanceAmount}>$7,783.00</Text>
  </View>
);

const InfoCard = ({ icon, title, amount, color }) => (
  <View style={styles.infoCard}>
    <Ionicons name={icon} size={28} color={color} />
    <View style={styles.infoTextContainer}>
      <Text style={styles.infoTitle}>{title}</Text>
      <Text style={[styles.infoAmount, { color }]}>{amount}</Text>
    </View>
  </View>
);

const TransactionItem = ({ item }) => {
  const isIncome = item.type !== 'expense';
  const amountString = `${isIncome ? '' : '-'}$${Math.abs(item.amount).toFixed(2)}`;
  const amountColor = isIncome ? 'green' : 'red';
  const iconColor = isIncome ? 'green' : 'red';
  const iconName = item.category === 'Food' ? 'fast-food-outline' : 'cash-outline';
  const date = new Date(item.timestamp);
  const formattedDate = `${date.getHours()}:${date.getMinutes()} - ${months[date.getMonth()]}`;


  return (
    <View style={styles.transactionItem}>
      <View style={[styles.transactionIconContainer, { backgroundColor: `${iconColor}1A` }]}>
        <Ionicons name={iconName} size={24} color={iconColor} />
      </View>
      <View style={styles.transactionDetails}>
        <Text style={styles.transactionTitle}>{item.title}</Text>
        <Text style={styles.transactionSubTitle}>{formattedDate}</Text>
      </View>
      <Text style={styles.transactionCategory}>{item.category}</Text>
      <View style={styles.divider} />
      <Text style={[styles.transactionValue, { color: amountColor }]}>{amountString}</Text>
    </View>
  );
};

const MonthSection = ({ month, transactions }) => (
    <View>
        <View style={styles.monthHeader}>
            <Text style={styles.monthTitle}>{month}</Text>
            <View style={styles.calendarIconContainer}>
                <Ionicons name="calendar-outline" size={20} color="#2ECC71" />
            </View>
        </View>
        <FlatList
            data={transactions}
            renderItem={({item}) => <TransactionItem item={item} />}
            keyExtractor={(item) => item.id.toString()}
            scrollEnabled={false} // The parent ScrollView will handle scrolling
        />
    </View>
);


const TransactionScreen = ({ navigation }) => {
  const [transactionsByMonth, setTransactionsByMonth] = useState({});

  useFocusEffect(
    React.useCallback(() => {
      const getData = async () => {
        const storedTransactions = await AsyncStorage.getItem('transactions');
        if (storedTransactions) {
          const allTransactions = JSON.parse(storedTransactions).sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

          if (allTransactions.length === 0) {
            Alert.alert("No Transactions", "You haven't added any transactions yet.", [
                { text: 'OK', onPress: () => navigation.navigate("Home") }
            ]);
            return;
          }

          const groupedByMonth = allTransactions.reduce((acc, tx) => {
              const monthName = months[new Date(tx.timestamp).getMonth()];
              if (!acc[monthName]) {
                  acc[monthName] = [];
              }
              acc[monthName].push(tx);
              return acc;
          }, {});

          setTransactionsByMonth(groupedByMonth);

        } else {
            Alert.alert("No Transactions", "You haven't added any transactions yet.", [
                { text: 'OK', onPress: () => navigation.navigate("Home") }
            ]);
        }
      };
      getData();
    }, [navigation])
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <BalanceCard />
        <View style={styles.infoRow}>
          <InfoCard icon="arrow-up" title="Income" amount="$4,120.00" color="green" />
          <InfoCard icon="arrow-down" title="Expense" amount="$1,187.40" color="blue" />
        </View>
      </View>
      <View style={styles.listContainer}>
        <ScrollView>
            {Object.entries(transactionsByMonth).map(([month, txs]) => (
                <MonthSection key={month} month={month} transactions={txs} />
            ))}
        </ScrollView>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#2ECC71',
  },
  header: {
    paddingTop: 40,
    paddingBottom: 60,
  },
  balanceCard: {
    marginHorizontal: 20,
    padding: 20,
    backgroundColor: 'white',
    borderRadius: 20,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.1,
    shadowRadius: 10,
    elevation: 5,
  },
  balanceTitle: {
    color: 'grey',
    fontSize: 16,
  },
  balanceAmount: {
    fontSize: 32,
    fontWeight: 'bold',
    color: 'black',
    marginTop: 8,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginTop: 20,
    paddingHorizontal: 20,
  },
  infoCard: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    backgroundColor: 'white',
    borderRadius: 20,
    marginHorizontal: 7.5
  },
  infoTextContainer: {
      marginLeft: 10,
  },
  infoTitle: {
    color: 'grey',
    fontSize: 14,
  },
  infoAmount: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  listContainer: {
    flex: 1,
    backgroundColor: 'white',
    borderTopLeftRadius: 40,
    borderTopRightRadius: 40,
    marginTop: -40,
    padding: 20,
  },
  monthHeader: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'center',
      marginBottom: 10,
      marginTop: 10,
  },
  monthTitle: {
      fontSize: 20,
      fontWeight: 'bold',
      color: 'black',
  },
  calendarIconContainer: {
      padding: 8,
      backgroundColor: '#2ECC712A', // light green
      borderRadius: 10,
  },
  transactionItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 10,
  },
  transactionIconContainer: {
      padding: 12,
      borderRadius: 15,
  },
  transactionDetails: {
      flex: 1,
      marginLeft: 12,
  },
  transactionTitle: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  transactionSubTitle: {
      fontSize: 12,
      color: 'grey',
  },
  transactionCategory: {
      color: 'grey',
      fontSize: 14,
      marginHorizontal: 10,
  },
  divider: {
      height: 30,
      width: 1,
      backgroundColor: '#E0E0E0',
  },
  transactionValue: {
      width: 90,
      textAlign: 'right',
      fontWeight: 'bold',
      fontSize: 16,
      marginLeft: 10,
  }
});

export default TransactionScreen;