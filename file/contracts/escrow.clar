(define-data-var job-counter uint 0)

(define-map jobs {
  job-id: uint
} {
  employer: principal,
  freelancer: (optional principal),
  amount: uint,
  status: (string-ascii 32)
})

(define-public (post-job (amount uint))
  (begin
    (let ((job-id (+ (var-get job-counter) u1)))
      (map-insert jobs
        {job-id: job-id}
        {employer: tx-sender, freelancer: none, amount: amount, status: "open"})
      (var-set job-counter (+ job-id u1))
      (ok job-id))))

(define-public (accept-job (job-id uint))
  (begin
    (match (map-get jobs {job-id: job-id})
      (some job)
      (begin
        (asserts! (is-eq (get status job) "open") (err u100)) ; Ensure job is open
        (map-set jobs {job-id: job-id} (merge job {freelancer: (some tx-sender), status: "accepted"}))
        (ok true))
      (none (err u101))))) ; Return error if job does not exist

(define-public (complete-job (job-id uint))
  (begin
    (match (map-get jobs {job-id: job-id})
      (some job)
      (let ((amount (get amount job))
            (freelancer (get freelancer job)))
        (asserts! (is-some freelancer) (err u102)) ; Ensure freelancer is assigned
        (asserts! (is-eq tx-sender (get employer job)) (err u103)) ; Ensure only employer can complete the job
        (map-set jobs {job-id: job-id} (merge job {status: "completed"}))
        (try! (stx-transfer? amount tx-sender (unwrap! freelancer (err u104)))) ; Transfer funds to freelancer
        (ok true))
      (none (err u105))))) ; Return error if job does not exist
