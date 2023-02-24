import { ethers, Contract } from "ethers";
import EVote from "@/artifacts/contracts/EVote.sol/EVote.json";

const getContract = async (): Promise<Contract> => {
  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  if (typeof window.ethereum !== "undefined") {
    // metamask as provider
    const provider = new ethers.BrowserProvider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, EVote.abi, provider);
    // console.log(await signer.getAddress());
    return contract;
  } else {
    // hardhat provider
    const provider = new ethers.JsonRpcProvider("http://localhost:8545/");
    const contract = new ethers.Contract(contractAddress, EVote.abi, provider);
    return contract;
  }
};

export default getContract;
