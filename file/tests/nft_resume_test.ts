```typescript
import { Clarinet, Tx, Chain, Account } from "@clarigen/test";

Clarinet.test({
  name: "Test NFT resume issuance",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let freelancer = accounts.get("wallet_1")!;

    // Issue NFT
    let issueResume = chain.mineBlock([
      Tx.contractCall("nft-resume", "issue-resume", ["\"Web Developer\""], freelancer.address)
    ]);
    issueResume.receipts[0].result.expectOk();
  }
});
```
