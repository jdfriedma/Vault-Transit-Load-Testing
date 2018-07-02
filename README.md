# Vault-Transit-Load-Testing
A project using the wrk testing framework to test HashiCorp Vault Transit Throughput

## How does this work?
This project uses the wrk benchmarking framework to test the throughput of HashiCorp Vault's transit backend in a number of scenarios. Included in this repo are a number of scripts, each with a value or series of values to encrypt. Wrk is able to take a lua script as an argument to read every time it executes a request, and so we are able to inject values to encrypt with each request.

This was tested in a single Vault node, connected to a single Consul node for storage. We only mounted a Transit secret engine to remove any confounding factors, and used a root token to again avoid a small amount of extra lookup overhead. We also repeatedly reuse the same values we encrypt since there's no caching of previously encrypted values in the Transit backend.

We suggest running wrk on a different server than your Vault instance to avoid noisy neighbor issues, although wrk uses relatively little overhead.

To use this framework, do the following:
1. Configure your Vault and Consul nodes. This guide assumes you're comfortable doing this, please reference the HashiCorp [Vault Getting Started Docs](https://www.vaultproject.io/intro/getting-started/install.html) if not.
2. Initialize your Vault server, [enable the Transit secret engine and write a keyring for your testing.](https://www.vaultproject.io/docs/secrets/transit/index.html#setup)
3. Git clone this repo into your load generation machine.
4. Install wrk on your load generation machine, following the instructions here: https://github.com/wg/wrk/wiki/Installing-Wrk-on-Linux
5. Run your workload. The makers of wrk recommend running a maximum of 1 thread per core. Play around with the number of connections you use to determine what the ideal settings for your system are. The connections are a **total** number of connections, split across your threads, as described here: https://github.com/wg/wrk#command-line-options
A sample wrk command to run these files looks like this: `wrk -t8 -c8 -d1m -H "X-Vault-Token: TOKEN_GOES_HERE_SO_PASTE_IT" -s /home/ubuntu/postbatch320.lua http://10.0.0.50:8200/v1/transit/encrypt/test` where the IP and path correspond to the Transit secret engine you'd configured.

## To-do List

1. Create a decrypt workload generator
2. Publish more public benchmarks based on different combinations of AWS instance types
3. Run benchmarks on Packet or similar
