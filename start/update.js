const client = require('./db.js');

const databaseDefinition = { id: "stocksdb" };
const collectionDefinition = { id: "stocks" };

const init = async () => {
  const { database } = await client.databases.createIfNotExists(databaseDefinition);
  const { container } = await database.containers.createIfNotExists(collectionDefinition);
  return { database, container };
}

const getPriceChange = () => {
  const min = 100;
  const max = 999;
  const change = min + (Math.random() * (max - min));
  const value = Math.round(change);
  return parseFloat((value / 100).toFixed(2));
}

const getStockChangeValues = (existingStock) => {
  const isChangePositive = !(existingStock.changeDirection === '+');
  const change = getPriceChange();
  let price = isChangePositive ? parseFloat(existingStock.price) + change : parseFloat(existingStock.price) - change;
  console.log('Updating price');
  console.log(existingStock.price);
  console.log('Change');
  console.log(change);
  console.log('New price');
  console.log(price);
  price = parseFloat(price.toFixed(2));
  return {
    "price": price,
    "change": change,
    "changeDirection": isChangePositive ? '+' : '-'
  };
};

const between = (min, max) => {  
  return Math.floor(
    Math.random() * (max - min + 1) + min
  )
};

const updateData = async ()  => {

  const { container } = await init();

  console.log('Read data from database.\n\n');

  id = 'e0eb6e85-176d-4ce6-89ae-1f699aaa0bab';

  switch(between(1,3)){
    case 1:
      id = 'e0eb6e85-176d-4ce6-89ae-1f699aaa0bab';
      break;
    case 2:
      id = 'ebe2e863-bf84-439a-89f8-39975e7d6766';
      break;
    case 3:
      id = '80bc1751-3831-4749-99ea-5c6a63105ae7';
      break;
  }
  
  const doc = await container.item(id);

  const { body: existingStock } = await doc.read();

  const updates = getStockChangeValues(existingStock);

  Object.assign(existingStock, updates);

  await doc.replace(existingStock);

  console.log(`Data updated: ${JSON.stringify(existingStock)}`);
};

updateData().catch(err => {
  console.error(err);
});
