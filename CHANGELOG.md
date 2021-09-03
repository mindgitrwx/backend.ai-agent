Changes
=======

<!--
    You should *NOT* be adding new change log entries to this file, this
    file is managed by towncrier. You *may* edit previous change logs to
    fix problems like typo corrections or such.

    To add a new change log entry, please refer
    https://pip.pypa.io/en/latest/development/contributing/#news-entries

    We named the news folder "changes".

    WARNING: Don't drop the last line!
-->

.. towncrier release notes start

21.03.11 (2021-09-03)
---------------------

### Features
* Auto-detect and configure Docker container creation parameters to support RDMA acceleration ([#300](https://github.com/lablup/backend.ai-agent/issues/300))
* Allow overriding of Docker container creation configs using a local JSON file (`agent-docker-container-opts.json` in the same location of `agent.toml` file) to allow monkey-patching them without restarting or redeploying the agents in running clusters ([#301](https://github.com/lablup/backend.ai-agent/issues/301))


21.03.10 (2021-09-02)
---------------------

### Features
* Allow overriding shell environment variable from image label ([#302](https://github.com/lablup/backend.ai-agent/issues/302))

### Fixes
* If there is no exact distro version in the match_distro_data function, the latest distro of the same kind will be returned (e.g.: ubuntu20.04 -> ubuntu16.04). ([#299](https://github.com/lablup/backend.ai-agent/issues/299))


21.03.9 (2021-08-23)
--------------------

### Features
* Add aiomonitor module for manager ([#295](https://github.com/lablup/backend.ai-agent/issues/295))
* Add `~/.local/bin` to the default PATH. ([#296](https://github.com/lablup/backend.ai-agent/issues/296))

### Miscellaneous
* Update package dependencies ([#297](https://github.com/lablup/backend.ai-agent/issues/297))


21.03.8 (2021-07-13)
--------------------

### Fixes
* Fix the regression of batch-type sessions by moving `startup_command` invocation to agents ([#293](https://github.com/lablup/backend.ai-agent/issues/293))


21.03.7 (2021-06-28)
--------------------

### Features
* Now individual container's hostname is set to the corresponding hostname in cluster sessions such as `main1`, `sub1`, etc. ([#291](https://github.com/lablup/backend.ai-agent/issues/291))


21.03.6 (2021-06-18)
--------------------

### Fixes
* Unify handling of unhandled exceptions to produce AgentError events and depreacte use of agent-side error monitor plugins ([#290](https://github.com/lablup/backend.ai-agent/issues/290))


21.03.5 (2021-06-13)
--------------------

### Features
* Implement an evenly-distributed allocation algorithm for `DiscretePropertyAllocMap`, which allows use of CPU overcommits by spreading out oversubscribed core assignments ([#288](https://github.com/lablup/backend.ai-agent/issues/288))

### Fixes
* Add explicit dependencies of type annotation packages required by latest mypy (≥0.900) ([#289](https://github.com/lablup/backend.ai-agent/issues/289))


21.03.4 (2021-06-07)
--------------------

### Fixes
* "PosixPath object has no attribute chown" error in changing the ownership of cluster SSH-keypair. ([#285](https://github.com/lablup/backend.ai-agent/issues/285))
* Make the lxcfs support to be more future-proof ([#287](https://github.com/lablup/backend.ai-agent/issues/287))


21.03.3 (2021-06-07)
--------------------

### Features
* An improved, colorized shell prompt with cluster hostname and session name. ([#283](https://github.com/lablup/backend.ai-agent/issues/283))
* Add support for lxcfs to provide a consistent view of `/proc/cpuinfo`, `/proc/meminfo`, `/proc/stat`, etc. inside containers ([#286](https://github.com/lablup/backend.ai-agent/issues/286))

### Fixes
* Clarify the error message for quantum size check failure after dividing the request amount into even slices in the allocation map ([#284](https://github.com/lablup/backend.ai-agent/issues/284))


21.03.2 (2021-05-17)
--------------------

### Features
* Add support for `BACKEND_MEM_OVERCOMMIT_FACTOR` environment variable to allow overriding the capacity of main memory for the scheduler, while reporting statistics as-is. ([#280](https://github.com/lablup/backend.ai-agent/issues/280))
* Place a mardkwon file inside a container under /home/work/ which warns data saving on homedir. ([#281](https://github.com/lablup/backend.ai-agent/issues/281))

### Miscellaneous
* Increase the maximum allowed overcommit factor of CPU cores from 4 to 10. ([#282](https://github.com/lablup/backend.ai-agent/issues/282))


21.03.1 (2021-05-14)
--------------------

### Fixes
* Stabilize container lifecycle management. ([#278](https://github.com/lablup/backend.ai-agent/issues/278))
  - Let the container cleanup task to explicitly wait for the container destruction task
    because the clean event may be fired and handled before the docker's container destroy API returns.
  - Do not create/destroy libzmq contexts for individual containers and reuse a single
    global context, because doing so may hang up when there are many concurrent
    creation/destruction operations going on.
  - Explicitly clean up async generators related to log collection.
  - Limit the concurrency of container creation and destruction to 4 using async semaphore.
  - Add more category switches to control verbosity of debug logs. (`events`, `alloc-map`, `kernel-config`)
  - Add explicit timeouts when calling the docker stats API because it may hang under high loads,
    but this seems to be not a complete solution yet.
* Refine the stability update by explicitly skipping over being-terminated containers when syncing container lifecycles periodically ([#279](https://github.com/lablup/backend.ai-agent/issues/279))


21.03.0 (2021-03-29)
--------------------

The v21.03.0 release is an integrated update for all features and fixes already applied to v20.09 series as additional patches, except that it now runs on top of Python 3.9.

### Features
* Use the agent's internal unique ID for the socket relay container name to improve multi-agent support ([#259](https://github.com/lablup/backend.ai-agent/issues/259))
* Enlarge the SFTP message buffer sizes to support big frame transportation ([#266](https://github.com/lablup/backend.ai-agent/issues/266))
* Add applying .tmux.conf.local file in .tmux.conf to reflect customized tmux configuration ([#277](https://github.com/lablup/backend.ai-agent/issues/277))

### Fixes
* Improve daemon shutdown stability using aiotools v1.2 ([#263](https://github.com/lablup/backend.ai-agent/issues/263))
* Fix indefinite hang of create_kernels() RPC call when there are in-container failures after starting a container but before the kernel runner gets ready ([#264](https://github.com/lablup/backend.ai-agent/issues/264))
* Fix SSHJ (the SSH client library shipped with IntelliJ/PyCharm IDEs) compatibility issue when sending large files over SFTP ([#265](https://github.com/lablup/backend.ai-agent/issues/265))
* Update dependencies including pyzmq, pytest, mypy, aioresponses, and python-snappy ([#267](https://github.com/lablup/backend.ai-agent/issues/267))
* Ensure initialization of the kernel runner even when there are failures during sshd initialization, to prevent indefinite manager hangs ([#268](https://github.com/lablup/backend.ai-agent/issues/268))
* Fix watcher startup failure after aiotools v1.2 upgrade ([#269](https://github.com/lablup/backend.ai-agent/issues/269))
* Refactor to use the shared `common.events` module to produce agent/kernel/session events to the internal event bus ([#270](https://github.com/lablup/backend.ai-agent/issues/270))
* Update uvloop to 0.15.1 for better Python 3.8/3.9 support (and drop Python 3.5/3.6 support) ([#271](https://github.com/lablup/backend.ai-agent/issues/271))
* Fix "get_container_pid -> -1: Error: required argument is not an integer" error in old Linux kernels (&lt; 4.1, which may include CentOS 7). ([#272](https://github.com/lablup/backend.ai-agent/issues/272))
* Ensure the proper permission for the user-configured SSH keypair ([#273](https://github.com/lablup/backend.ai-agent/issues/273))
* Fix a problem that cannot launch all service apps once one app fails to open service port. ([#274](https://github.com/lablup/backend.ai-agent/issues/274))
* Update pyzmq to v22 series to reduce its wheel distribution size and fix a fork-safety bug introduced in v20. ([#275](https://github.com/lablup/backend.ai-agent/issues/275))
* Fix a critical regression to miss setting `source` parameter when producing events from the event dispatcher refactoring (#270) ([#276](https://github.com/lablup/backend.ai-agent/issues/276))


20.09.2 (2021-01-04)
--------------------

### Features
* Allow environment customization by `/opt/container/bootstrap.sh` defined by individual images by sourcing it instead of executing ([#261](https://github.com/lablup/backend.ai-agent/issues/261))

### Fixes
* Reliable scp support inside container: scp now references correct ssh binary located in /usr/bin/.
  - Force scp to use the specified ssh implementation in Backend.AI ([#260](https://github.com/lablup/backend.ai-agent/issues/260))


20.09.1 (2020-12-29)
--------------------

### Fixes
* Fix too minimal PATH environment variable when using SSH sessions across different containers in a multi-container session due to the hard-coded default in dropbear ([#258](https://github.com/lablup/backend.ai-agent/issues/258))


20.09.0 (2020-12-27)
--------------------

### Fixes
* Stabilization of multi-node multi-container support ([#257](https://github.com/lablup/backend.ai-agent/issues/257))
  - Simplify the Docker Swarm status detection
  - Handle partial failures during batch kernel creation, by reporting the first error, and let successful containers as-is because they will be destroyed by the manager
  - Add suppress-events option to `destroy_kernel()` RPC function to "silenty" destroy kernels for recovery after partial multi-node multi-container session spawn failures


20.09.0rc2 (2020-12-24)
-----------------------

### Fixes
* Fix races of kernel creation events by tracking the creation request IDs ([#256](https://github.com/lablup/backend.ai-agent/issues/256))


20.09.0rc1 (2020-12-23)
-----------------------

### Features
* Improve multi-node cluster session resource management
  - Apply the even allocator by default for `FractionAllocMap`
  - Add more options to customize allocation strategies to `FractionAllocMap`
  - Allow cusotmization of the quantum size (i.e., base of multiple) of allocation ([#255](https://github.com/lablup/backend.ai-agent/issues/255))


20.09.0b3 (2020-12-21)
----------------------

### Features
* Add `get_node_hwinfo()` base method for compute plugins for hardware metadata queries.  Currently the intrinsic compute plugins report nothing. ([#253](https://github.com/lablup/backend.ai-agent/issues/253))


20.09.0b2 (2020-12-20)
----------------------

### Fixes
* Raise the `kernel_started` event by ourselves to fix a race condition of event handling during kernel creation ([#254](https://github.com/lablup/backend.ai-agent/issues/254))


20.09.0b1 (2020-12-18)
----------------------

### Breaking Changes
* Update `AbstractAllocMap` interface to have explicit per-slot/per-device resource metadata, unifying prior allocmap-sepcific init args, and thus all compute plugins must be updated to instantiate alloc maps properly though the plugin interface itself has not been changed ([#248](https://github.com/lablup/backend.ai-agent/issues/248))

### Features
* Implement the `UNIQUE` resource slot type and exclusive resource slot checks to support CUDA MIG devices ([#248](https://github.com/lablup/backend.ai-agent/issues/248))

### Fixes
* Improve statistics collection by applying aiofiles and batching of per-container stat queries ([#248](https://github.com/lablup/backend.ai-agent/issues/248))
* Change dotfiles' owner inside compute session from root to work. ([#249](https://github.com/lablup/backend.ai-agent/issues/249))
* Stabilize the container lifecycle monitoring routines to handle missed events for exited containers and keep reconnecting to the docker daemon when actively disconnected ([#250](https://github.com/lablup/backend.ai-agent/issues/250))
* Update plugin dependencies and now they are installed together with the agent using extra requirements, e.g., `pip install backend.ai-agent[cuda,datadog,sentry]`.  This replaces the manually managed compatibility matrix in each plugin, by ensuring that pip will check the version ranges of plugis. ([#251](https://github.com/lablup/backend.ai-agent/issues/251))

### Miscellaneous
* Update dependencies and adapt with the new pip resolver ([#247](https://github.com/lablup/backend.ai-agent/issues/247))
* Reorganize GitHub Actions workflows and drop use of psf-chronographer and Travis CI ([#252](https://github.com/lablup/backend.ai-agent/issues/252))


20.09.0a5 (2020-12-02)
----------------------

### Features
* Improve compatibility with arbitrary Linux containers by using a statically built Python for kernel-runners compatible with manylinux2010, which eliminates, for instance, OpenSSL dependency in the containers ([#242](https://github.com/lablup/backend.ai-agent/issues/242))

### Fixes
* Fix a regression to spawning GPU sessions, by passing the original container distribution value (taken from image labels, e.g., `ubuntu16.04`) to compute plugins' `get_hooks()` method instead of the matched result (e.g., `static-gnu`) since the responsibility of choosing the optimal hook binary is on the plugin itself. ([#243](https://github.com/lablup/backend.ai-agent/issues/243))
* Fix hangs of existing containers which access the agent socket after agent restarts due to the dangling inode, by running a persistent socat container to relay the mounted UNIX sockets and the agent socket bound to a local TCP port ([#244](https://github.com/lablup/backend.ai-agent/issues/244))
* Let dropbear (intrinsic in-container ssh client) skip checks for the host fingerprints when connecting to other hosts in the same cluster ([#245](https://github.com/lablup/backend.ai-agent/issues/245))
* Keep the hook filenames consistent to support distributed computing apps such as Horovod that comes with config propagation ([#246](https://github.com/lablup/backend.ai-agent/issues/246))


20.09.0a4 (2020-11-16)
----------------------

### Fixes
* Fire `execution_started` and `execution_finished` events around the code execution routine to work with the new idle checker framework ([#239](https://github.com/lablup/backend.ai-agent/issues/239))


20.09.0a3 (2020-11-03)
----------------------

### Fixes
* Fix a critical regression of user-requested app starts due to pre-starting sshd/ttyd services ([#240](https://github.com/lablup/backend.ai-agent/issues/240))


20.09.0a2 (2020-10-30)
----------------------

### Features
* Add support for shutting down running in-container services ([#230](https://github.com/lablup/backend.ai-agent/issues/230))

### Fixes
* Update the krunner packages to run kernel runners (in-container daemons) on more recent Python version (3.8.6) and custom build of ttyd to fix periodic disconnection of terminals ([#237](https://github.com/lablup/backend.ai-agent/issues/237))
* Update broken dependencies (aiohttp~=3.7.0, trafaret~=2.1) ([#238](https://github.com/lablup/backend.ai-agent/issues/238))


20.09.0a1 (2020-10-06)
----------------------

### Features
* Add support for multi-container sessions ([#164](https://github.com/lablup/backend.ai-agent/issues/164))
* Add evenly-distributed resource allocator for `AllocMap` instances ([#228](https://github.com/lablup/backend.ai-agent/issues/228))
* Add a configuration option to allow skipping running manager detection upon agent startup ([#234](https://github.com/lablup/backend.ai-agent/issues/234))

### Fixes
* Fix a regression of container statistics collection with recent aiodocker versions (0.16 or later) ([#226](https://github.com/lablup/backend.ai-agent/issues/226))
* Fix missing `allow_extra` options in config input validators, which is a newly exposed regression after ff019ac9 ([#227](https://github.com/lablup/backend.ai-agent/issues/227))
* Add context parameter for init methods of intrinsic accelerators. ([#229](https://github.com/lablup/backend.ai-agent/issues/229))
* Fix vfolder mounts for compute sessions using agent host paths provided by the storage proxy ([#231](https://github.com/lablup/backend.ai-agent/issues/231))
* Allow keypair/group/domain dotfiles to have absolute path from / ([#232](https://github.com/lablup/backend.ai-agent/issues/232))
* Skip vfolder configuration checks and assume use of storage proxies if the vfolder mount path in etcd is not specified ([#233](https://github.com/lablup/backend.ai-agent/issues/233))
* Refactor out validation of service port declaration ([#235](https://github.com/lablup/backend.ai-agent/issues/235))
* Fix a regression of task-log filename by introduction of new environment variables ([#236](https://github.com/lablup/backend.ai-agent/issues/236))


20.03.0 (2020-07-28)
--------------------

* No changes since RC1

20.03.0rc1 (2020-07-23)
-----------------------

### Features
* Add support for Ubuntu 20.04 as base-distro for session images
* Allow overriding of intrinsic compute devices (`cpu` and `mem`) using compute device plugins ([#224](https://github.com/lablup/backend.ai-agent/issues/224))

### Fixes
* Move invocation of user-defined bootstrap script from the container entrypoint to the krunner's main loop for better log visibility and ability to interrupt ([#225](https://github.com/lablup/backend.ai-agent/issues/225))


20.03.0b2 (2020-07-02)
----------------------

### Breaking Changes
* Apply the plugin API v2 -- all stat/error/accelerator plugins must be updated along with the agent ([#222](https://github.com/lablup/backend.ai-agent/issues/222))

### Features
* Allow kernel containers to know their identities via `BACKENDAI_KERNEL_ID` environment variable ([#218](https://github.com/lablup/backend.ai-agent/issues/218))
* Global configuration for agent/container
  - Global configuration on etcd overrides existsing local configuration for agent/container. ([#219](https://github.com/lablup/backend.ai-agent/issues/219))

### Fixes
* Fix instability caused by stat-synchronizer processes under heavy loads by collecting statistics periodically only ([#212](https://github.com/lablup/backend.ai-agent/issues/212))
* Apply batching when producing "kernel_stat_sync" events to reduce manager loads and increase timeout for caching stats in Redis from 30 seconds to 2 minutes ([#213](https://github.com/lablup/backend.ai-agent/issues/213))
* Improve stability under heavily loaded scenarios ([#214](https://github.com/lablup/backend.ai-agent/issues/214))
  - Skip lifecycle sync for already terminating kernels to reduce excessive Docker Engine overheads with a many number of being-terminated kernels
  - Increase timeout for container termination to 60 seconds during restarting kernels, by observing deletion latencies under heavy load tests
* Prevent executing startup command multiple times for batch session. ([#217](https://github.com/lablup/backend.ai-agent/issues/217))
* Stabilize container lifecycle management and RPC exception handling with updated Callosum ([#218](https://github.com/lablup/backend.ai-agent/issues/218))
* Make it possible to add more backend implementations by generalizing importing and initialization of backend modules ([#222](https://github.com/lablup/backend.ai-agent/issues/222))
* Fix hang-up of service-port functionality of a session when one of its service starts but fails to initialize ([#223](https://github.com/lablup/backend.ai-agent/issues/223))


20.03.0b1 (2020-05-12)
----------------------

### Breaking Changes
* - Now it runs on Python 3.8 or higher only.

### Features
* Now we support ROCM (Radeon Open Compute) accelerators via `backend.ai-accelerator-rocm` plugin.
* Now our manager-to-agent RPC uses [Callosum](https://github.com/lablup/callosum) instead of aiozmq, supporting Python 3.8 natively. ([#157](https://github.com/lablup/backend.ai-agent/issues/157))
* Support user-defined bootstrap script (e.g., this can be used to clone a git repo) ([#161](https://github.com/lablup/backend.ai-agent/issues/161))
* ResourceSlots are now more permissive. Agent still checks the validity of known slots but also allows zero-valued unknown slots as well. ([#162](https://github.com/lablup/backend.ai-agent/issues/162))
* All CLI commands are now accessible via `backend.ai ag` ([#165](https://github.com/lablup/backend.ai-agent/issues/165))
* Add support for pre-open service ports for user-written apps ([#167](https://github.com/lablup/backend.ai-agent/issues/167))
* Add a new "app" kernel-runner runtime type for GUI and application-only kernels ([#189](https://github.com/lablup/backend.ai-agent/issues/189))
* Mark kernel started after bootstrap script is executed ([#190](https://github.com/lablup/backend.ai-agent/issues/190))
* Generalize kernel-runner volume lists using plugin-like krunner package auto-detection ([#198](https://github.com/lablup/backend.ai-agent/issues/198))

### Deprecations
* Using CentOS 6.10 as the base distribution for importing images is deprecated. ([#189](https://github.com/lablup/backend.ai-agent/issues/189))

### Fixes
* Detection for manager now works for HA setup seamlessly. (It now determines if at least one manager is running.) [lablup/backend.ai#125](https://github.com/lablup/backend.ai/issues/125)
* Fix wrong ownership of .ssh and keypair files when the SSH keypair is set via the `internal_data` field of the kernel creation config.
* Make scratch directory accesses for setup/tear-down fully asynchronous ([#186](https://github.com/lablup/backend.ai-agent/issues/186))
* Fix service-port parsing routines to recognize "vnc-web" service ports for GUI containers ([#189](https://github.com/lablup/backend.ai-agent/issues/189))
* Make the kernel runner's service parser consistent with documentation ([#197](https://github.com/lablup/backend.ai-agent/issues/197))
* Update test fixtures to work with pytest-asyncio 0.11 and use a separate registry state data file for each test sessions ([#208](https://github.com/lablup/backend.ai-agent/issues/208))
* Update test fixtures to work with pytest-asyncio 0.12 ([#209](https://github.com/lablup/backend.ai-agent/issues/209))
* Fix lifecycle-related code errors when handling results of batch-mode tasks ([#210](https://github.com/lablup/backend.ai-agent/issues/210))

### Miscellaneous
* Now the kernel-runner runs on the prebuilt Python 3.8 mounted inside containers. ([#189](https://github.com/lablup/backend.ai-agent/issues/189))
* Adopt [towncrier](https://github.com/twisted/towncrier) to manage changelogs. ([#196](https://github.com/lablup/backend.ai-agent/issues/196))
* Update flake8 to a prerelease version supporting Python 3.8 syntaxes ([#211](https://github.com/lablup/backend.ai-agent/issues/211))
