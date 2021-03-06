pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;

contract EtherChat {


	struct Msg {
		string sender;
		uint msg_type; //1-text,2-file
		string data;
	}

	address public s;
	
	event msgAdd(address sender, string reciver, string data, uint msg_type); 
	event msgSearch(string senderList, string sender);

	constructor () public {
		usernames[0xfCAE8fE9C7757014a5b028686250cD1C28c2269b] = "01";
		usernames[0xC134252dEdef77ea78A0CeD1d918c443e1C0739A] = "00";
		subscriberList[usernames[0xC134252dEdef77ea78A0CeD1d918c443e1C0739A]].push("01");
		Msg memory t = Msg(usernames[0xfCAE8fE9C7757014a5b028686250cD1C28c2269b],1,"Hello");
		users[usernames[0xfCAE8fE9C7757014a5b028686250cD1C28c2269b]]["00"] = t;
		s = msg.sender;


	} 

	mapping (string  => mapping (string  => Msg)) users;
	mapping (string  => string[] ) subscriberList;
	mapping (address => string ) public usernames ;
	mapping (string => bool) ListOfAllUsernames;
	mapping (address => bool) ListOfAllAccounts;
	
	
	
	function publishMsg (string memory reciver, string memory data, uint msg_type) public {
		users[usernames[msg.sender]][reciver] = Msg(usernames[msg.sender],msg_type,data);
		emit msgAdd(msg.sender, reciver, data, msg_type);
		
	}
	
	function getMsg (string memory sender) public returns(Msg[100] memory){
		string[100] memory msgs;
		Msg memory temp;
		Msg[100] memory toReturn;
		uint i;
		uint count = 0;
		string memory myUsername = usernames[msg.sender];
		string[] memory mySubscribers = subscriberList[myUsername];

		for(i=0; i < mySubscribers.length; ++i){
			temp = users[mySubscribers[i]][myUsername];
		
				emit msgSearch(temp.sender,sender);
				if(_strcomp(temp.sender,sender)){
					msgs[count] = temp.data;
					toReturn[count] = temp;
					count++;
				}
			
		}
		return toReturn;
	}

	function addUser (string memory username) public {
		if(ListOfAllAccounts[msg.sender]==true)
			return;
		if(ListOfAllUsernames[username]==true)
			return;
		usernames[msg.sender]  = username;
		ListOfAllUsernames[username] = true;
		ListOfAllAccounts[msg.sender] = true;
		s = msg.sender;
		
	}
	
	function getUsername () public returns(string memory){
		return usernames[msg.sender];
	}
	
	function subscribe (string memory username) public {
		if(!_isPresentInList(subscriberList[usernames[msg.sender]], username)){
			subscriberList[usernames[msg.sender]].push(username);
		}
	}
	
	function _isPresentInList (string[] memory list, string memory _str) private returns (bool) {
		uint i=0;
		for(i=0; i<list.length; ++i){
			if(_strcomp(_str,list[i])){
				return true;
			}
		}
		return false;
	}

	function _strcomp (string memory s1, string memory s2) private returns(bool res) {
		if(keccak256(abi.encodePacked((s1))) == keccak256(abi.encodePacked((s2))))
			return true;
		else
			return false;
	}
	
	
}