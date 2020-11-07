    <?php 
	include("../Includes/session.php");
	include("../Includes/config.php");
    $id=$_SESSION['uid'];
    $comp=$_POST["complaint"];
    $aid=0;
    $status="NOT PROCESSED";
    
    if(isset($_POST["complaint"]) && !empty($_POST["complaint"]))
    {
        $query  = "INSERT INTO complaint(id,uid,aid,complaint,status)";
        $query .= " VALUES ({$id},{$uid},{$aid},{$comp},{$status})";
        mysqli_query($con,$query);  
    }
    
    header("Location:complaint.php");   
    ?>