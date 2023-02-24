import { ethers, Contract, BrowserProvider } from "ethers";
import EVote from "@/artifacts/contracts/EVote.sol/EVote.json";

const getProvider = (): ethers.BrowserProvider | ethers.JsonRpcProvider => {
  if (typeof window.ethereum !== "undefined") {
    // metamask as provider
    return new ethers.BrowserProvider(window.ethereum);
    // await provider.send("eth_requestAccounts", []);
    // console.log(signer.getAddress());
  } else {
    // hardhat provider
    return new ethers.JsonRpcProvider("http://localhost:8545/");
  }
};

const getContract = async (): Promise<Contract> => {
  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const provider = getProvider();
  const signer = await provider.getSigner();
  const contract = new ethers.Contract(contractAddress, EVote.abi, signer);
  return contract;
};

export { getProvider, getContract };
