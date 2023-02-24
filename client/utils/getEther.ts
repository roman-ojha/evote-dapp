import { ethers } from "ethers";

const getEther = (): ethers.BrowserProvider | unknown => {
  return new Promise((resolve, reject) => {
    if (typeof window.ethereum !== "undefined") {
      // await requestAccount();
      try {
        const provider = new ethers.BrowserProvider(window.ethereum);
        resolve(provider);
      } catch (err) {
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
        } catch (err) {
          console.log(err);
        }
      } else {
        console.log("Wallet doesn't exist");
      }
    }
  });
};

export default getEther;
