<?php
	$servername = "localhost";
	$username = "root";
	$password = "";
	$dbname = "sailormoonstore";
	$conn = mysqli_connect($servername, $username, $password, $dbname);
	if (!$conn) 
    {
		die("Connection failed: " . mysqli_connect_error());
	}
?>
<?php
                    $order_id = 12345;
                if (isset($_POST['id']) && isset($_POST['price'])){
                    $product_id = (int)$_POST['id'];
                    $product_price = (int)$_POST['price'];
                    $sql = "SELECT * FROM order_detail WHERE product_id='$product_id' AND order_id = '$order_id'";
                    $result = $conn->query($sql);
                    if ($result->num_rows > 0) {
                        $sql1 = "CALL update_addquantity('$order_id','$product_id');";
                        mysqli_query($conn, $sql1);
                    } else {
                    $sql2 = "Call insert_orderdetail('$order_id','$product_id');";
                        mysqli_query($conn, $sql2);
                    }
                } else if (isset($_POST['minus'])) {
                    $product_id = (int)$_POST['minus'];
                    $sql = "CALL update_decrquantity('$order_id','$product_id');";
                    mysqli_query($conn, $sql);
                } else if (isset($_POST['plus'])) {
                    $product_id = (int)$_POST['plus'];
                    $sql = "CALL update_addquantity('$order_id','$product_id');";
                    mysqli_query($conn, $sql);
                } else if (isset($_POST['payment'])) {
                    // $order_id = (int)$_POST['payment'];
                    // $sql = "SELECT * FROM order_detail WHERE order_id='$order_id'";
                    // $result = $conn->query($sql);  
                    // if ($result->num_rows > 0) {
                    //   while($row = $result->fetch_assoc()) {
                    //     $quantity = $row["quantity"];
                    //     $product_id = $row["product_id"];
                    //     $sql1 = "UPDATE product SET quantity = quantity - '$quantity' WHERE id='$product_id'";
                    //     mysqli_query($conn, $sql1);
                    //   }
                    // }
                    // $sql2 = "DELETE FROM order_detail WHERE order_id='$order_id'";
                    // mysqli_query($conn, $sql2);
                    $order_status = $_POST['payment'];
                    $sql = "UPDATE orders SET order_status = '$order_status' WHERE id='$order_id'";
                    mysqli_query($conn, $sql);
                }
    
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/product.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
    integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA=="
    crossorigin="anonymous" referrerpolicy="no-referrer" />
    <title>Sailor Moon Store Online</title>
    
</head>
<body>
<header>
        <div class="upper">
            <div class="logo">
                <a href="#">
                    <img src="https://sailormoon-store.com/img/usr/common/logo.png" alt="Logo">
                </a>
            </div>

            <div class="search-bar">
                <input type="search" name="search" id="search">

                <span><i class="fa fa-search" aria-hidden="true"></i></span>
            </div>
            
            <div class="social-media">
                <span><a href="#"><i class="fa-brands fa-x-twitter"></i></a></span>
                <span><a href="#"><i class="fa-brands fa-instagram"></i></a></span>
            </div>

        </div>
        <nav>
            <ul>
                <li><a href="#">Home</a></li>
                <li><a href="product.php">Shop</a></li>
                <li><a href="bill.php">Bills</a></li>
                <li><a href="employee.php">Employees</a></li>
                <li><a href="stat.php">Statistics</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <h1>Welcome</h1>
        <h2>月に代わってお仕置きよ!</h2>

    </main>
    <?php
    $sql1 = "SELECT product_id,unit_price,promo_amount, quantity FROM order_detail WHERE order_id='$order_id'";
    $result1 = $conn->query($sql1);
    $subTotal = 0;
    $discount = 0;
    $sql3 = "
    SELECT discount_amount FROM membership_level WHERE level=(
        SELECT card_level FROM membership_card WHERE cus_id = (
            SELECT cus_id FROM orders WHERE id = '$order_id'
            )
     );
    ";
    $discount_member = $conn->query($sql3)->fetch_assoc()["discount_amount"];
    if ($result1->num_rows > 0) {
        echo "
        <div class='orderWrapper'>
        <h1 class='orderTitle'>ORDER</h1>
        <div class='orderDetail'>   
        <div class='orderLeft'>
        ";
      while($row1 = $result1->fetch_assoc()) {
        $subTotal += $row1["quantity"]*$row1["unit_price"];
        $discount += $row1["quantity"]*$row1["unit_price"]*$row1["promo_amount"]/100;
        $temp = $row1["product_id"];
        $imageSrc = "images/" . $row1["product_id"] . ".jpg";
        echo "
        <div class='orderProduct'>
        <div class='orderProductDetail'>
            <img src='". $imageSrc ."' class='orderImage'/>";    
            $sql2 = "SELECT name, size, material, color FROM product WHERE id='$temp'";
            $result2 = $conn->query($sql2);
            if ($result2->num_rows > 0) {    
              while($row2 = $result2->fetch_assoc()) {
                echo "
                <div class='orderProductDetails'>
                    <span class='orderProductName'><b>Product name: </b> ".$row2["name"]."</span>
                    <span class='orderProductSize'><b>Size: </b> ".$row2["size"]."</span>
                    <span class='orderProductColor'><b>Color: </b> ".$row2["color"]."</span>
                    <span class='orderProductMaterial'><b>Material: </b> ".$row2["material"]."</span>
                </div>
                </div>
                ";
              }
            }   
            echo "
        <div class='orderPriceDetail'>
        <div class='orderProductAmountContainer'>
        <form method='POST'>
        <input type='hidden' id='minus' name='minus' value='$temp'>
        <button type='submit'><i class='fa-solid fa-minus'></i></button>
        </form>
        <div class='orderProductAmount'>".$row1["quantity"]."</div>
        <form method='POST'>
        <input type='hidden' id='plus' name='plus' value='$temp'>
        <button type='submit'><i class='fa-solid fa-plus'></i></button>
        </form>
        </div>
        <div class='orderProductPrice'>".$row1["unit_price"]."VND</div>
    </div>
</div>
<hr class='Hr'/>
        ";
      }
      echo "
      </div>
      <div class='orderRight'>
          <h1 class='SummaryTitle'>ORDER SUMMARY</h1>
          <div class='SummaryItem'>
              <span class='SummaryItemText'>Subtotal</span>
              <span class='SummaryItemPrice'>".$subTotal."VND</span>
          </div>
          <div class='SummaryItem'>
              <span class='SummaryItemText'>Discount for product</span>
              <span class='SummaryItemPrice'>".$discount."  VND</span>
          </div>
          <div class='SummaryItem'>
          <span class='SummaryItemText'>Discount for member</span>
          <span class='SummaryItemPrice'>".$discount_member."  %</span>
          </div>
          <div class='SummaryItem'>
              <span class='SummaryItemText'><b>Total</b></span>
              <span class='SummaryItemPrice'><b>".($subTotal-$discount)*(100-$discount_member)/100 ."VND</b></span>
          </div>
          <form method='POST'>
          <input type='hidden' id='payment' name='payment' value='Đang xử lý'>
          <button class='orderButton'>CHECKOUT NOW</button>
          </form>  
      </div>
  </div>
</div>
      ";
    }
    ?>
    <?php
    $sql = "SELECT id,name, price, size, material, color, quantity FROM product";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        echo "<div class='products'>";
      while($row = $result->fetch_assoc()) {
        $imageSrc = "images/" . $row["id"] . ".jpg";
        echo "
        <div class='product'>
        <img class='productImg' src='". $imageSrc ."' alt='' />
        <div class='productInfo'>
        <span class='productTitle'>".$row["name"]."</span>
        <div class='productInfoDetail'>
        <span class='productSize'>Size: ".$row["size"]."</span>
        <span class='productPrice'>In stock: ".$row["quantity"]."</span>
        </div>
        <div class='productInfoDetail'>
        <span class='productColor'>Color: ".$row["color"]."</span>
        <span class='productStock'>Material: ".$row["material"]."</span>
        </div>
        <span class='productTitle'>Price: ".$row["price"]."</span>
        <form method='POST'>
            <input type='hidden' id='id' name='id' value='".$row["id"]."'>
            <input type='hidden' id='price' name='price' value='".$row["price"]."'>
            <button type='submit'>Add to cart</button>
        </form>
    </div>
    </div>
        ";
      }
      echo "</div>";
    }
    ?>
    <footer>
        <p>2023 No Copyright by Sailor Moon Team HCMUT</p>
    </footer>
</body>
</html>

