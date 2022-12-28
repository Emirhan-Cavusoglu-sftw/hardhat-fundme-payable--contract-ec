require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("hardhat-deploy");
const GOERLI_RPC_URL=process.env.GOERLI_RPC_URL;
const PRIVATE_KEY=process.env.PRIVATE_KEY;
const ETHERSCAN_API_KEY=process.env.ETHERSCAN_API_KEY;
const COINMARKET_API_KEY=process.env.COINMARKET_API_KEY;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  // solidity: "0.8.17",
  solidity:{
      compilers:[{version:"0.8.17"},{version:"0.6.6"}] 
  },
  namedAccounts:{
    deployer:{
      default:0,
    },
    user:{
      default:1,
    }
  },
  defaultNetwork:"hardhat",
  networks:{
    goerli:{
     url:GOERLI_RPC_URL,
     accounts:[PRIVATE_KEY],
     chainId:5,
     blockConfirmations: 6, 
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
    

},
gasReporter: {
  enabled: false,
  currency: "USD",
  outputFile: "gas-report.txt",
  noColors: true,
  // coinmarketcap: COINMARKETCAP_API_KEY, eğer eth değerleri lazımsa yorumdan çıkarabilirsiniz ve false true yapmanız lazım
},
};
