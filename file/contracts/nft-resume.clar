(define-non-fungible-token resume-nft {id: uint, skill: (string-ascii 64)})

(define-data-var resume-counter uint 0)

(define-public (issue-resume (skill (string-ascii 64)))
  (let ((resume-id (var-get resume-counter)))
    (begin
      (try! (nft-mint? resume-nft {id: resume-id, skill: skill} tx-sender)) ; Mint the NFT
      (var-set resume-counter (+ resume-id u1)) ; Increment the resume counter
      (ok resume-id)))) ; Return the resume ID

(define-read-only (get-resume-owner (resume-id uint))
  (let ((owner (nft-get-owner? resume-nft {id: resume-id, skill: ""})))
    (match owner
      (some principal) (ok principal) ; Return the owner principal if found
      (none (err u200))))) ; Error if resume is not found
