```typescript
import { Clarinet, Tx, Chain, Account } from "@clarigen/test";

Clarinet.test({
  name: "Test posting and accepting jobs",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let employer = accounts.get("deployer")!;
    let freelancer = accounts.get("wallet_1")!;

    // Post a job
    let postJob = chain.mineBlock([
      Tx.contractCall("escrow", "post-job", ["u1000"], employer.address)
    ]);
    postJob.receipts[0].result.expectOk();

    // Accept the job
    let acceptJob = chain.mineBlock([
      Tx.contractCall("escrow", "accept-job", ["u1"], freelancer.address)
    ]);
    acceptJob.receipts[0].result.expectOk();
  }
});
```
