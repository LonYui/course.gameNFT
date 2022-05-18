require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.1",
  networks:{
    rinkeby:{
      url:'https://eth-rinkeby.alchemyapi.io/v2/8jgh0nqTx-6ZKJii90FJSjV7h6Rw7VHR',
      accounts:['2e735582a2995841bbe857ed7335fd094b3897a5c45d8374b38cb7611cc7cb9f'],
    }
  }
};
