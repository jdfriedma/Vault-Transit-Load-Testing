
-- example HTTP POST script which demonstrates setting the
-- HTTP method, body, and adding a header

wrk.method = "POST"
wrk.body   = '{"plaintext" : "dGVldkV0R2ZodVV5Yk9zUA=="}'
wrk.headers["Content-Type"] = "application/json"
