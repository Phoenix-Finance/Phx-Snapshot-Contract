const fs = require('fs');
const path = require('path');

const schemaString = fs.readFileSync(
  path.resolve(__dirname, './schema.graphql'),
  'utf8',
);
console.log('schemaString', schemaString);
module.exports = {
  extends: [
    'airbnb-base',
    'plugin:import/errors',
    'plugin:import/warnings',
    'prettier',
  ],
  rules: {
    'no-console': 0,
    'graphql/template-strings': ['error', { env: 'apollo', schemaString }],
    'prettier/prettier': 'error',
  },
  plugins: ['graphql', 'prettier'],
};
