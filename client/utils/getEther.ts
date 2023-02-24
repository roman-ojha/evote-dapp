import { ethers } from "ethers";

const getEther = (): any => {
  return new Promise(async (resolve, reject) => {
    if (typeof window.ethereum !== "undefined") {
      // const account = await requestAccount();
      try {
        const provider = new ethers.BrowserProvider(window.ethereum);
        resolve(provider);
      } catch (err: any) {
        reject(err);
      }
    }

    // get the account
    async function requestAccount() {
      // first check whether metamask exist or not
      if (window.ethereum) {
        console.log("Wallet Detected");
        try {
          // get all the account from metamask
          const accounts = await window.ethereum.request({
            method: "eth_requestAccounts",
          });
          return accounts[0];
        } catch (err) {
          console.log(err);
          return "";
        }
      } else {
        console.log("Wallet doesn't exist");
        return "";
      }
    }
  });
};

export default getEther;
