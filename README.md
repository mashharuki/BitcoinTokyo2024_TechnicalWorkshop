# Bitcoin Tokyo 2024 Technical Workshop

## Instrucitons

- [English](https://docs.google.com/document/d/1uocAbHHI6CrIe6MWa6gdhoZLjpmh5HAsHUl0j6q9rKE/edit?usp=sharing)
- [日本語](https://docs.google.com/document/d/1okmvrc6Ll5USOApr1dtPRuQNoY_ppC5KyYURb35qmi0/edit?usp=sharing)

## フォルダ概要

- `Dockerfile` ... sparrow をビルドする例となる Dockerfile
- `docker_for_bdkcli/` ... `bdk-cli` をテストする際の docker compose 及びスクリプト

## ハンズオン記憶

- 作成したウォレット

  [Testnet - tb1q5knlttpagghz34x7ft9nu3pjqpkr8kllzn3wn6](https://blockstream.info/testnet/search?q=tb1q5knlttpagghz34x7ft9nu3pjqpkr8kllzn3wn6)

  [Mainnet - bc1q0xcmcshu0ngvn5264telknq5cxzyhnvmxunn05](https://blockstream.info/address/bc1q0xcmcshu0ngvn5264telknq5cxzyhnvmxunn05)

  [Signet - tb1qm6xmp7nmva72fps3jstkpu2mpsvsj5vc2p06tf](https://explorer.bc-2.jp/address/tb1qm6xmp7nmva72fps3jstkpu2mpsvsj5vc2p06tf)

- BDK CLI のインストール

  ```bash
  cargo install bdk-cli --features=compiler,regtest-bitcoin
  ```

  以下でバージョン情報を確認する。

  ```bash
  bdk-cli --version
  ```

- スクリプトのコンパイル

  ```bash
  bdk-cli compile 'and(pk(A),or(pk(B),or(9@pk(C),older(1000))))'
  ```

  ```json
  {
    "descriptor": "wsh(and_v(or_c(pk(B),or_c(pk(C),v:older(1000))),pk(A)))#d963x3qy"
  }
  ```

- 鍵ペアの生成

  ```bash
  bdk-cli key generate
  ```

  ```bash
  bdk-cli key derive
  ```

  以下のように組み合わせることもできる。

  ```bash
  bdk-cli key generate | jq .xprv | xargs -IXX bdk-cli key derive --xprv XX --path='m/84'/1'/0'/0''
  ```

  ```json
  {
    "xprv": "[8363c57a/84/1/0/0]tprv8ipJLdeSxdgmsVBJDd1aymCPLe7v8UVgQtMU6nkzWLcJNEKtGPjQYFrqEAm5krFV2KN3BqFgPgMZWrGroEGLh3q2UqLGhAqzwMDphs9T1ak/*",
    "xpub": "[8363c57a/84/1/0/0]tpubDFWLV3gh71NSkxD67GgBPArVufdrHogazBxFPJoHvcQhCiaetnYzikUhQLFQhCmSKPsButsgnYEPAknDTFAxee989dcPKSpPC2JdzjWc3J6/*"
  }
  ```

- bdk cli のオンライン機能を試す方法

  `docker_for_bdkcli` ディレクトリ配下で実行すること

  ```bash
  docker compose up
  ```

  立ち上がったら以下のコマンドを実行してみる。

  ```bash
  bdk-cli-example.sh
  ```

- BDK のウォレット機能を改造してみる。

  ```bash
  git clone https://github.com/bitcoindevkit/bdk
  ```

  以下のディレクトリに移動する。

  ```bash
  cd bdk/example-crates/wallet_rpc
  ```

  以下のコマンドを実行

  ```bash
  cargo run --bin wallet_rpc -- --rpc-user=foo --rpc-pass=bar --network=regtest --start-height=1 --url=127.0.0.1:43782 "wpkh([8363c57a/84/1/0/0]tprv8ipJLdeSxdgmsVBJDd1aymCPLe7v8UVgQtMU6nkzWLcJNEKtGPjQYFrqEAm5krFV2KN3BqFgPgMZWrGroEGLh3q2UqLGhAqzwMDphs9T1ak/*)" "wpkh([8363c57a/84/1/0/0]tprv8ipJLdeSxdgmsVBJDd1aymCPLe7v8UVgQtMU6nkzWLcJNEKtGPjQYFrqEAm5krFV2KN3BqFgPgMZWrGroEGLh3q2UqLGhAqzwMDphs9T1ak/1/*)"
  ```

  以下のような結果が得られます。

  ```bash
  Connected to Bitcoin Core RPC at GetBlockchainInfoResult { chain: Regtest, blocks: 0, headers: 0, best_block_hash: 0f9188f13cb7b2c71f2a335e3a4fc328bf5beb436012afca590b1a11466e2206, difficulty: 4.6565423739069247e-10, median_time: 1296688602, verification_progress: 1.0, initial_block_download: true, chain_work: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], size_on_disk: 293, pruned: false, prune_height: None, automatic_pruning: None, prune_target_size: None, softforks: {}, warnings: String("") }
  Loaded wallet in 0.038738918s
  Wallet balance before syncing: 0 BTC
  Wallet tip: 0f9188f13cb7b2c71f2a335e3a4fc328bf5beb436012afca590b1a11466e2206 at height 0
  ```

- BDK の RPC CLI を試してみる。

  ```bash
  docker compose exec -it bitcoind -datadir=/tmp/regtest/bitcoind -regtest -rpcuser=foo -rpcpassword=foo -named createwallet wallet_name="test"
  ```

### 参考文献

1. [プレゼン資料](https://docs.google.com/presentation/d/1Jnypr-KBHLR0baA3x8cVI6oYqIRPTkFAB7gHZ5hv-Gg/edit)
2. [Signet Coin 送付用スプレッドシート](https://docs.google.com/spreadsheets/d/16zmPVvdm%5C_yUHIRrUJrhJ9iWyzpTOzsdZxXcCtO4g5Yo/edit?usp=sharing)
3. [Luma - Base58 アジア初開催！ビットコイン基礎講座～マルチシグでの安全管理法から L2 開発基盤のスクリプトまで一気に習得～](https://lu.ma/6rw3uaxw?locale=ja)
4. [Sparrow Bitcoin Wallet](https://sparrowwallet.com/)
5. [Bitcoin Faucet](https://bitcoinfaucet.uo1.net/)
6. [Bitcoin Faucet2](https://coinfaucet.eu/en/btc-testnet/)
7. [Sparrowallet クイックスタート](https://sparrowwallet.net/ja/docs/quick-start/)
8. [Jade の使い方！ビットコイン特化のハードウェアウォレットを解説](https://bitcoin-zukan.com/practical/jade/)
9. [Blockstream Green 公式サイト](https://blockstream.com/green/)
10. [Jade のファームウェアをアップデートするサイト](https://jadefw.blockstream.com/upgrade/fwupgrade.html)
11. [GitHub - Blockstream/Jade](https://github.com/Blockstream/Jade)
12. [Set up Jade Guide](https://help.blockstream.com/hc/en-us/articles/19629901272345-Set-up-Jade)
13. [Signet Explorer](https://explorer.bc-2.jp/)
14. [Bitcoin Signet を触ってみよう](https://tech.hashport.io/1301/)
15. [ビットコインとか勉強会#34 - Bitcoin Signet ハンズオン](https://speakerdeck.com/shukob/bitcoin-signethanzuon)
16. [Jade で完全エアギャップ Bitcoin 送金](https://lostinbitcoin.jp/how-to/jadeairgapguide/)
17. [ハンズオン中に送信したトランザクション](https://mempool.space/signet/tx/224f69bf852662b5ac680bbcea64ee429bd20f71c45265494b28cf41fd9fac62)
18. [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)
19. [2-of-2 マルチシグで送金したトランザクション履歴](https://mempool.space/signet/tx/a406fe0b1aeb88504fb3345c04fdcacf7b77bdcabbf82b744f0706e8283c809a)
20. [Bitcoin Dev Kit Getstarted](https://bitcoindevkit.org/getting-started/)
21. [Docs - Crate bdk_wallet](https://docs.rs/bdk_wallet/latest/bdk_wallet/)
22. [Using BDK with hardware wallets](https://bitcoindevkit.org/blog/using-bdk-with-hardware-wallets/)
