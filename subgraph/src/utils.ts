import { BigInt, BigDecimal, ethereum } from '@graphprotocol/graph-ts';

import { Contract, LatestBalance, Transaction } from '../generated/schema';

export function createEventID(event: ethereum.Event): string {
  return event.block.number
    .toString()
    .concat('-')
    .concat(event.logIndex.toString());
}

export function fetchContract(address: string): Contract {
  let contract = Contract.load(address);
  if (contract == null) {
    contract = new Contract(address);
    contract.totalSupply = BigDecimal.fromString('0');
  }
  return contract as Contract;
}

export function fetchLatest(account: string, contract: string): LatestBalance {
  let latest = LatestBalance.load(account.concat('-').concat(contract));
  if (latest == null) {
    latest = new LatestBalance(account.concat('-').concat(contract));
    latest.account = account;
    latest.contract = contract;
    latest.balance = BigDecimal.fromString('0');
  }
  return latest as LatestBalance;
}

export function logTransaction(event: ethereum.Event): Transaction {
  let tx = new Transaction(event.transaction.hash.toHex());
  tx.from = event.transaction.from.toHex();
  // tx.to          = fetchAccount(event.transaction.to.toHex()  ).id;
  // tx.value       = event.transaction.value;
  // tx.gasUsed     = event.transaction.gasUsed;
  // tx.gasPrice    = event.transaction.gasPrice;
  tx.timestamp = event.block.timestamp;
  tx.blockNumber = event.block.number;
  tx.save();
  return tx as Transaction;
}

export function toETH(value: BigInt): BigDecimal {
  return value.divDecimal(BigDecimal.fromString('1000000000000000000'));
}
