import { v4 as uuidv4 } from 'react-native-uuid';

class TransactionModel {
  constructor({ timestamp, amount, title, message, category, type }) {
    this.id = uuidv4();
    this.timestamp = timestamp;
    this.amount = amount;
    this.title = title;
    this.message = message;
    this.category = category;
    this.type = type;
  }
}

export default TransactionModel;