CREATE TABLE activity_stat_coeffs (
   subject_type VARCHAR(255),
   action VARCHAR(20),
   value INT,

   UNIQUE INDEX id (subject_type, action)
)
;

INSERT INTO activity_stat_coeffs
   (subject_type,   action,    value)
VALUES
   ("Announce",     "create",  1000),
   ("Discussion",   "create",  5000),
   ("Message",      "create",  1000),
   ("Message",      "edit",    300 ),
   ("News",         "create",  3500),
   ("NewsComment",  "create",  600 ),
   ("ProfilTag",    "create",  400 )
;

CREATE VIEW activity_stats AS
SELECT
   account.id AS account_id,
   SUM(coeff.value) / (
         SELECT SUM(coeff.value) FROM activities
         JOIN activity_stat_coeffs coeff
            ON coeff.subject_type = activities.subject_type
            AND coeff.action = activities.action) AS sql_value
FROM activities activity
JOIN activity_stat_coeffs coeff
   ON coeff.subject_type = activity.subject_type
   AND coeff.action = activity.action
RIGHT JOIN accounts account
   ON account.id = activity.actor_id
GROUP BY
   account.id
;
