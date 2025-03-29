<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 페이지</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@700&display=swap">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f9f9f9;
        }

        .header {
            text-align: center;
            margin: 20px 0;
        }

        .background-menu {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .menu {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 1200px;
            width: 90%;
        }

        .menu h2 {
            margin-bottom: 35px;
            font-size: 36px;
            font-weight: 850;
            color: #333;
        }

        .category {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
        }

        .category button {
            padding: 10px 20px;
            background-color: rgba(63, 158, 39, 0.9);
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .category button:hover {
            background-color: rgba(63, 158, 39, 1);
        }

        .item {
            display: inline-block;
            margin: 10px;
            cursor: pointer;
        }

        .item img {
            width: 200px;
            height: 200px;
            border-radius: 10px;
            object-fit: cover;
            cursor: pointer;
            transition: transform 0.3s ease;
            border: 5px solid rgb(255, 255, 182);
        }

        .item img:hover {
            transform: scale(1.1);
        }

        .shopping-cart {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 10px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
        }

        .shopping-cart h3 {
            text-align: center;
            margin-bottom: 10px;
        }

        .cart-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 5px;
            border-bottom: 1px solid #ccc;
        }

        .cart-item .item-info {
            flex: 1;
        }

        .cart-item .item-info .name {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .cart-item .item-info .price {
            font-size: 0.8em;
            color: #666;
        }

        .cart-item .remove-btn {
            color: red;
            cursor: pointer;
        }

.total-price {
    margin-top: 10px;
    text-align: right;
    font-weight: bold;
}

.checkout {
    text-align: center;
    margin-top: 20px;
}

.checkout button {
    padding: 10px 20px;
    background-color: #28a745;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.checkout button:hover {
    background-color: #218838;
}

/* 모달 스타일 */
.modal {
    display: none;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgb(0,0,0);
    background-color: rgba(0,0,0,0.4);
    padding-top: 60px;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            border-radius: 10px;
            text-align: center;
        }

        .modal-content h2 {
            margin: 10px 0;
            font-size: 24px;
            color: #333;
        }

        .modal-content img {
            width: 100%;
            height: auto;
            border-radius: 10px;
            margin-bottom: 10px;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }


        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        .add-to-cart {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .add-to-cart:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <%
        String dbUrl = "jdbc:mariadb://10.100.0.120/cafe";
        String dbUser = "boss";
        String dbPassword = "sd12!fg34";
        String userId = request.getParameter("id");

        if (userId == null) {
            response.sendRedirect("http://10.100.100.100/index.jsp");
            return;
        }

        String username = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            String sql = "SELECT id FROM users WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                username = rs.getString("id");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (username == null) {
            response.sendRedirect("http://10.100.100.100/index.jsp");
            return;
        }
    %>
    <div class="header">
        <h3><%= username %>님 환영합니다!</h3>
    </div>

    <div class="background-menu" id="backgroundMenu">
        <div class="menu">
            <h2>MEGA MENU</h2>
            <div class="category">
                <button onclick="filterMenu('all')">ALL MENU</button>
                <button onclick="filterMenu('drink')">DRINK MENU</button>
                <button onclick="filterMenu('food')">FOOD MENU</button>
                <button onclick="filterMenu('product')">PRODUCT MENU</button>
            </div>
            <div id="menuItems" class="menu-items">
                <div class="item drink" onclick="openModal('딸기 초코', 2500)">
                    <img src="image/딸기 초코.jpg" alt="DRINK MENU">
                </div>
                <div class="item drink" onclick="openModal('오레오 초코', 1500)">
                    <img src="image/오레오 초코.JPG" alt="DRINK MENU">
                </div>
                <div class="item drink" onclick="openModal('모히또 에이드', 15000)">
                    <img src="image/모히또 에이드.JPG" alt="DRINK MENU">
                </div>
                <div class="item food" onclick="openModal('브라운 곰돌 빵', 3000)">
                    <img src="image/브라운 곰돌 빵.JPG" alt="FOOD MENU">
                </div>
                <div class="item food" onclick="openModal('핑크 곰돌 빵', 3000)">
                    <img src="image/핑크 곰돌 빵.JPG" alt="FOOD MENU">
                </div>
                <div class="item food" onclick="openModal('마루 홀 케이크', 15000)">
                    <img src="image/마루 홀 케이크.JPG" alt="FOOD MENU">
                </div>
                <div class="item product" onclick="openModal('마루 텀블러', 25000)">
                    <img src="image/마루 텀블러.JPG" alt="PRODUCT MENU">
                </div>
                <div class="item product" onclick="openModal('마루 고구마 인형', 15000)">
                    <img src="image/마루 고구마 인형.JPG" alt="PRODUCT MENU">
                </div>
                <div class="item product" onclick="openModal('마루 인형', 10000)">
                    <img src="image/마루 인형.JPG" alt="PRODUCT MENU">
                </div>
            </div>
        </div>
    </div>

    <div class="shopping-cart">
        <h3>장바구니</h3>
        <div id="cartItems"></div>
        <div class="total-price" id="totalPrice"></div>
        <div class="checkout">
            <button onclick="checkout()">주문하기</button>
        </div>
    </div>

    <div id="modalContainer"></div>
    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <img id="modal-img" src="" alt="Menu Image">
            <div class="name" id="modal-name"></div>
            <div class="price" id="modal-price"></div>
            <button class="add-to-cart" onclick="addToCart()">장바구니에 추가</button>
        </div>
    </div>

    <div id="orderCompleteModal" class="modal">
        <div class="modal-content">
            <h2>주문 완료되었습니다!</h2>
        </div>
    </div>

    <script>
        // 모달 파일을 불러오기
        fetch('modal.html')
            .then(response => response.text())
            .then(data => {
                document.getElementById('modalContainer').innerHTML = data;
            });

        let cart = [];

        setTimeout(() => {
            const loginCompleteMessage = document.getElementById('loginCompleteMessage');
            loginCompleteMessage.style.opacity = '0';
            setTimeout(() => {
                loginCompleteMessage.style.display = 'none';
                document.getElementById('backgroundMenu').style.display = 'flex';
            }, 1000);
        }, 2000);

        function filterMenu(category) {
            const items = document.querySelectorAll('.item');
            items.forEach(item => {
                const categories = item.classList;
                item.style.display = (category === 'all' || categories.contains(category)) ? 'inline-block' : 'none';
            });
        }

        function openModal(name, price) {
            const modal = document.getElementById('myModal');
            const modalImg = document.getElementById('modal-img');
            const modalName = document.getElementById('modal-name');
            const modalPrice = document.getElementById('modal-price');

            modalImg.src = `image/${name}.jpg`;
            modalName.textContent = name;
            modalPrice.textContent = `가격: ₩${price.toLocaleString()}`;

            modal.style.display = 'block';
        }

        function closeModal() {
            const modal = document.getElementById('myModal');
            modal.style.display = 'none';
        }

        function addToCart() {
            const modalName = document.getElementById('modal-name').textContent;
            const modalPrice = document.getElementById('modal-price').textContent;

            cart.push({ name: modalName, price: modalPrice });
            updateCart();
        }

        function updateCart() {
            const cartItemsContainer = document.getElementById('cartItems');
            const totalPriceContainer = document.getElementById('totalPrice');
            let totalPrice = 0;

            cartItemsContainer.innerHTML = '';

            cart.forEach((item, index) => {
                const cartItemDiv = document.createElement('div');
                cartItemDiv.classList.add('cart-item');
                cartItemDiv.innerHTML = `
                    <div class="item-info">
                        <div class="name">${item.name}</div>
                        <div class="price">${item.price}</div>
                    </div>
                    <div class="remove-btn" onclick="removeFromCart(${index})">&times;</div>
                `;
                cartItemsContainer.appendChild(cartItemDiv);

                const priceNumber = parseInt(item.price.replace('₩', '').replace(',', '').trim(), 10);
                totalPrice += priceNumber;
            });

totalPriceContainer.textContent = `총 가격: ₩${totalPrice.toLocaleString()}`;

const checkoutButton = document.querySelector('.checkout button');
checkoutButton.disabled = cart.length === 0;
}

function removeFromCart(index) {
cart.splice(index, 1);
updateCart();
}

function checkout() {
const orderCompleteModal = document.getElementById('orderCompleteModal');
orderCompleteModal.style.display = 'block';
cart = [];
updateCart();

setTimeout(() => {
    orderCompleteModal.style.display = 'none';
}, 2000);
}

filterMenu('all');
</script>
</body>
</html>
