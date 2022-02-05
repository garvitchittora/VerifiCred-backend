const main = async () => {
  const verifiCredContractFactory = await hre.ethers.getContractFactory('VerifiCred');
  const verifiCredContract = await verifiCredContractFactory.deploy();
  await verifiCredContract.deployed();
  console.log("Contract deployed to:", verifiCredContract.address);
  let tx = await verifiCredContract.createDegree(1, "0xD993717A21073e33525d3378D14332eF962fD7A9", "");
  await tx.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();