// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CroudFunding {
   
   struct Campaign{
    address owner;
    string title;
    string descrtption ;
    uint256 target;
    uint256 deadline;
    uint256 amountCollected;
    string image;
    address[] donators;
    uint256[] donations;
   }

   mapping(uint256 => Campaign) public campaigns;

   uint256 public numberOfCompaigns=0;

   function createCompaign(address _owner ,string memory _title , string memory _description, uint _target ,uint _deadline , string memory _image)public returns(uint256){
    Campaign storage campaign=campaigns[numberOfCompaigns];
    require(campaign.deadline  < block.timestamp ,"the deadline shoud be a date in the future ");
    
    campaign.owner=_owner;
    campaign.title=_title;
    campaign.target=_target;
    campaign.deadline=_deadline;
    campaign.amountCollected=0;
    campaign.image=_image;

    numberOfCompaigns++;

    return numberOfCompaigns -1 ;

   }

   function donateToCompaign(uint256 _id) public payable {

      uint256 amount=msg.value;

      Campaign storage campaign=campaigns[_id];

      campaign.donators.push(msg.sender);
      campaign.donations.push(amount);

      (bool sent,)=payable(campaign.owner).call{value : amount}("");

      if(sent){
        campaign.amountCollected =campaign.amountCollected+amount ;  
      }
      
   }

   function getDonators(uint256 _id) view public returns(address[] memory,uint256[] memory) {
      return (campaigns[_id].donators , campaigns[_id].donations);
   }

   function getCompaigns()public view returns(Campaign[] memory){
   
   Campaign[] memory allCampaign=new Campaign[](numberOfCompaigns);

   for(uint i=0;i<numberOfCompaigns;i++){
      Campaign storage item =campaigns[i];
      
      allCampaign[i]=item;

   }

   return allCampaign;

   }



}