async function deleteTweet() {
  console.log(event.target.parentNode.parentNode.parentNode);
  // delete from database
  let tweetForDelete = event.target.parentNode.parentNode.parentNode;
  let deleteTweet = new FormData();
  deleteTweet.append('tweet_id', event.target.parentNode.parentNode.parentNode.id);

  let connection = await fetch('api/api-delete-tweet.php', {
    method: 'POST',
    body: deleteTweet,
  });
  if (connection.status != '200') {
    console.log('tweet could not be deleted');
    return;
  }
  // delete from DOM
  tweetForDelete.remove();
}
