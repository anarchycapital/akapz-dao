// chain/data/params.ts
/*
    Deployment parameters
 */



// @ts-ignore
export const TestParams:any = {
    Token: {
        name: "Akapz DAO",
        symbol: "AKAP",
        // @ts-ignore
        owner: ""
    },
    Founders: [

    ],
}

export const proposalsFile = "proposals.json"

// Governor Values
export const QUORUM_PERCENTAGE = 4 // Need 4% of voters to pass
export const MIN_DELAY = 3600 // 1 hour - after a vote passes, you have 1 hour before you can enact
// export const VOTING_PERIOD = 45818 // 1 week - how long the vote lasts. This is pretty long even for local tests
export const VOTING_PERIOD = 5 // blocks
export const VOTING_DELAY = 1 // 1 Block - How many blocks till a proposal vote becomes active
export const ADDRESS_ZERO = "0x0000000000000000000000000000000000000000"

export const FUNC = "store"


export const DEV_AKAPZ_TOKEN = "0xd7122313d6906afE2E6E4Dda53898EcAa5A76338";
export const DEV_TIMELOCK = "0x022858EA74e59Fbb4E332A731f8cef55Df2eb7fb";
export const DEV_GOVERNOR = "0xD8d967256f91b7290AF2d9001D1D574f0Af99818";