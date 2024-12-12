(define-non-fungible-token resume-nft {id: uint, skill: (string-ascii 64)})

(define-data-var resume-counter uint 0)

(define-public (issue-resume (skill (string-ascii 64)))
  (let ((resume-id (var-get resume-counter)))
    (begin
      (try! (nft-mint? resume-nft {id: resume-id, skill: skill} tx-sender))
      (var-set resume-counter (+ resume-id u1))
      (ok resume-id))))

(define-read-only (get-resume-owner (resume-id uint))
  (nft-get-owner? resume-nft {id: resume-id, skill: ""}))
