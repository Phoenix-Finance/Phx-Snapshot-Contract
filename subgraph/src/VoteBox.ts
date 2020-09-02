import {
  Proposal as ProposalEvent,
  Vote as VoteEvent,
} from '../generated/VoteBox/VoteBox';

import { Account, Proposal, Vote } from '../generated/schema';

import { logTransaction } from './utils';

export function handleProposal(event: ProposalEvent): void {
  let proposal = new Proposal(event.params.id.toString());
  let account = new Account(event.transaction.from.toHex());
  proposal.transaction = logTransaction(event).id;
  proposal.proposer = account.id;
  proposal.timestamp = event.block.timestamp;
  proposal.link = event.params.link;
  proposal.beginBlock = event.params.beginBlock;
  proposal.endBlock = event.params.endBlock;
  account.save();
  proposal.save();
}

export function handleVote(event: VoteEvent): void {
  let account = new Account(event.params.voter.toHex());
  let vote = new Vote(
    event.params.id.toString().concat('-').concat(account.id),
  );
  vote.transaction = logTransaction(event).id;
  vote.timestamp = event.block.timestamp;
  vote.voter = account.id;
  vote.proposal = event.params.id.toString();
  switch (event.params.voteContent) {
    case 0:
      vote.content = 'INVALID';
      break;
    case 1:
      vote.content = 'FOR';
      break;
    case 2:
      vote.content = 'AGAINST';
      break;
  }
  account.save();
  vote.save();
}
