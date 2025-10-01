import { v4 as uuidv4 } from 'react-native-uuid';

class CategoriesModel {
  constructor({ categoryName, iconCodePoint }) {
    this.id = uuidv4();
    this.categoryName = categoryName;
    this.iconCodePoint = iconCodePoint;
  }
}

export default CategoriesModel;