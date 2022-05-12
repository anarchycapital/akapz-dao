export const AkapzABI = [
    "constructor(string,string,address)",
    "event AdminChanged(address,address)",
    "event Approval(address indexed,address indexed,uint256)",
    "event BeaconUpgraded(address indexed)",
    "event DelegateChanged(address indexed,address indexed,address indexed)",
    "event DelegateVotesChanged(address indexed,uint256,uint256)",
    "event Deposited(address indexed,uint256)",
    "event RoleAdminChanged(bytes32 indexed,bytes32 indexed,bytes32 indexed)",
    "event RoleGranted(bytes32 indexed,address indexed,address indexed)",
    "event RoleRevoked(bytes32 indexed,address indexed,address indexed)",
    "event Transfer(address indexed,address indexed,uint256)",
    "event Upgraded(address indexed)",
    "function DEFAULT_ADMIN_ROLE() view returns (bytes32)",
    "function DOMAIN_SEPARATOR() view returns (bytes32)",
    "function allowance(address,address) view returns (uint256)",
    "function approve(address,uint256) returns (bool)",
    "function balanceOf(address) view returns (uint256)",
    "function checkpoints(address,uint32) view returns (tuple(uint32,uint224))",
    "function decimals() view returns (uint8)",
    "function decreaseAllowance(address,uint256) returns (bool)",
    "function delegate(address)",
    "function delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)",
    "function delegates(address) view returns (address)",
    "function getPastTotalSupply(uint256) view returns (uint256)",
    "function getPastVotes(address,uint256) view returns (uint256)",
    "function getRoleAdmin(bytes32) view returns (bytes32)",
    "function getRoleMember(bytes32,uint256) view returns (address)",
    "function getRoleMemberCount(bytes32) view returns (uint256)",
    "function getVotes(address) view returns (uint256)",
    "function grantRole(bytes32,address)",
    "function hasRole(bytes32,address) view returns (bool)",
    "function increaseAllowance(address,uint256) returns (bool)",
    "function name() view returns (string)",
    "function nonces(address) view returns (uint256)",
    "function numCheckpoints(address) view returns (uint32)",
    "function permit(address,address,uint256,uint256,uint8,bytes32,bytes32)",
    "function proxiableUUID() view returns (bytes32)",
    "function renounceRole(bytes32,address)",
    "function revokeRole(bytes32,address)",
    "function s_maxSupply() view returns (uint256)",
    "function supportsInterface(bytes4) view returns (bool)",
    "function symbol() view returns (string)",
    "function totalSupply() view returns (uint256)",
    "function transfer(address,uint256) returns (bool)",
    "function transferFrom(address,address,uint256) returns (bool)",
    "function upgradeTo(address)",
    "function upgradeToAndCall(address,bytes) payable"
  ];