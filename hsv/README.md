# hsv

### Seeing the demo

Use `make feedback-loop` to build and run the executable in a loop.

See `make help` for a list of other targets.

See `vault-encrypt-transit` and `vault-decrypt-transit` in particular, for a very interesting workflow.

See also targets for running the demo.

### Other Notes

"working" is a pretty low bar as of right now:

```
Will now connect to Vault!
hsv-exe: VaultException_BadStatusCode "POST" "http://127.0.0.1:8200/v1/secret/data/hsv" "{\"data\":{\"A\":\"a\",\"B\":\"b\"}}" 200 "{\"request_id\":\"88b52af9-a8d7-b853-930d-edeb8d308d82\",\"lease_id\":\"\",\"renewable\":false,\"lease_duration\":0,\"data\":{\"created_time\":\"2018-10-30T05:14:24.699794738Z\",\"deletion_time\":\"\",\"destroyed\":false,\"version\":8},\"wrap_info\":null,\"warnings\":null,\"auth\":null}\n"
```

The `vault-tool` lib that this demo uses has some issues, for example, with our
use of `vaultWrite` we get a `BadStatusCode` even though we have recevied a `200`.

But it works enough to get some basic interaction between Vault and Haskell.
