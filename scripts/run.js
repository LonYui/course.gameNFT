const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame')
    const gameContract = await gameContractFactory.deploy(
        ["水箭龜","超大型巨人","上弦之六"],//names
        ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.serebii.net%2Fpokemonunite%2Fpokemon%2Fblastoise.shtml&psig=AOvVaw2uZ8SbhAGpzagNVVpVDCm_&ust=1652379742600000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCJCliK-I2PcCFQAAAAAdAAAAABAD",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSWgvyYRLlbvM5Ftum9ZGqVIY7pZt9QBJlMg&usqp=CAU",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0ioxFfGQ7MHcjwVcs1hA5EjkuMvF_alDcgg&usqp=CAU",],
        [1.5*100,2*100,(1/2)*100],//hp
        [(1/1.5)*30,(1/2)*30,2*30]//atk
    )
    await gameContract.deployed()
    console.log(`contract deployed at:${gameContract.address}`)

    let txn;
    txn = await gameContract.mintCharaterNFT(2);
    await txn.wait();

    let NFTURI = await gameContract.tokenURI(1)
    console.log(`token uri = ${NFTURI}`)
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