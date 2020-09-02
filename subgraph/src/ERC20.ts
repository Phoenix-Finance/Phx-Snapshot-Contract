import { Transfer as TransferEvent } from '../generated/MCB/IERC20';

import { Account, Transfer, Balance } from '../generated/schema';

import {
  createEventID,
  fetchContract,
  fetchLatest,
  logTransaction,
  toETH,
} from './utils';

export function handleTransfer(event: TransferEvent): void {
  let contract = fetchContract(event.address.toHex());
  let from = new Account(event.params.from.toHex());
  let to = new Account(event.params.to.toHex());
  let ev = new Transfer(createEventID(event));

  ev.transaction = logTransaction(event).id;
  ev.timestamp = event.block.timestamp;
  ev.contract = contract.id;
  ev.from = from.id;
  ev.to = to.id;
  ev.value = toETH(event.params.value);

  if (from.id == '0x0000000000000000000000000000000000000000') {
    contract.totalSupply += ev.value;
  }

  if (to.id == '0x0000000000000000000000000000000000000000') {
    contract.totalSupply -= ev.value;
  }

  if (from.id != '0x0000000000000000000000000000000000000000') {
    let latestFrom = fetchLatest(from.id, contract.id);
    latestFrom.balance -= ev.value;
    latestFrom.totalSupply = contract.totalSupply;
    latestFrom.transaction = ev.transaction;
    latestFrom.block = event.block.number;
    latestFrom.save();

    let balanceFrom = new Balance(
      latestFrom.id.concat('-').concat(event.block.number.toString()),
    );
    balanceFrom.account = from.id;
    balanceFrom.contract = contract.id;
    balanceFrom.balance = latestFrom.balance;
    balanceFrom.totalSupply = contract.totalSupply;
    balanceFrom.transaction = ev.transaction;
    balanceFrom.block = event.block.number;
    balanceFrom.save();
  }

  if (to.id != '0x0000000000000000000000000000000000000000') {
    let latestTo = fetchLatest(to.id, contract.id);
    latestTo.balance += ev.value;
    latestTo.totalSupply = contract.totalSupply;
    latestTo.transaction = ev.transaction;
    latestTo.block = event.block.number;
    latestTo.save();

    let balanceTo = new Balance(
      latestTo.id.concat('-').concat(event.block.number.toString()),
    );
    balanceTo.account = to.id;
    balanceTo.contract = contract.id;
    balanceTo.balance = latestTo.balance;
    balanceTo.totalSupply = contract.totalSupply;
    balanceTo.transaction = ev.transaction;
    balanceTo.block = event.block.number;
    balanceTo.save();
  }

  contract.save();
  from.save();
  to.save();
  ev.save();
}
