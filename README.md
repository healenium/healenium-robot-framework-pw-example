# healenium-robot-framework-pw-example

[![Docker Pulls](https://img.shields.io/docker/pulls/healenium/hlm-backend.svg?maxAge=25920)](https://hub.docker.com/u/healenium)
[![License](https://img.shields.io/badge/license-Apache-brightgreen.svg)](https://www.apache.org/licenses/LICENSE-2.0)

Healenium with Robot Framework (Playwright) via [robotframework-browser](https://github.com/MarketSquare/robotframework-browser) and the **healenium-playwright-proxy** WebSocket endpoint.

## Architecture

Since **RobotFramework Browser** is the Playwright **client** (`BrowserType.connect` over WebSocket)

**Healenium Playwright** is the WebSocket proxy, that bridges to `playwright run-server` with healing.

```
Robot Framework  (healenium_tests, resource.robot)
        |
        |  [test code only]
        v
robotframework-browser  (Node + Playwright connect)
        |
        |  WebSocket
        v
Healenium Playwright Proxy  (:8095, path /hlm-playwright-proxy)
        |
        +---------------->  hlm-backend + postgres-db  (HTTP: healing / storage)
        |
        v  (forwards)
playwright run-server
(browser in container)
```

## How to start

### 1. Install Robot Framework

Install dependencies and the Browser library’s Playwright bundle:

```sh
python3 -m pip install -r requirements.txt
python3 -m Browser.entry init
```

### 2. Start Healenium components

**Playwright version:** the `playwright-server` image in the compose file must use the same major Playwright as **robotframework-browser** (the library bundles `playwright` in its Node wrapper). 

The **Client version** can be checked under `…/site-packages/Browser/wrapper/node_modules/playwright-core/package.json` after Robot Framework is installed.

Start the Playwright stack:

```sh
docker compose -f healenium/docker-compose-pw-proxy.yaml up -d
```

Verify these services are up:

- `postgres-db` (PostgreSQL for selectors / healing / report)
- `healenium` (hlm-backend, port `7878` on the host in this file)
- `playwright-server` (Playwright `run-server`, used by the proxy)
- `healenium-playwright-proxy` (port `8095` — WebSocket path `/hlm-playwright-proxy`)

### 3. Connect from tests

Tests use the Browser library: **`Connect To Browser`** with a **WebSocket** URL, not a Selenium `http://` Remote WebDriver URL.

```robot
*** Variables ***
${PROXY_URL}    ws://localhost:8095/hlm-playwright-proxy
${BROWSER}      chromium

Open Remote Chrome Browser
    PWB.Connect To Browser    ${PROXY_URL}    ${BROWSER}
    PWB.New Page    ${TEST_PAGE}
```

See `healenium_tests/resource.robot` for the full resource file (including `Library  Browser  WITH NAME  PWB`).

### 4. Run test

From the project root, run the tests in `healenium_tests` with:

```sh
python3 -m robot healenium_tests
```

## Community / Support

* [Telegram chat](https://t.me/healenium)
* [YouTube Channel](https://www.youtube.com/channel/UCsZJ0ri-Hp7IA1A6Fgi4Hvg)
