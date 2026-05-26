package com.team404.controller;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.team404.domain.ProductDetailDto;
import com.team404.domain.User;
import com.team404.service.NotificationService;
import com.team404.service.OrderService;
import com.team404.service.ProductService;
import com.team404.service.ReviewService;
import com.team404.service.UserService;

import jakarta.servlet.http.HttpSession;
import com.team404.domain.Order;

@Controller
public class OrderController {

	@Autowired
	private OrderService orderService;

	@Autowired
	private ProductService productService;

	@Autowired
	private UserService userService;

	@Autowired
	private ReviewService reviewService;

	@Autowired
	private NotificationService notificationService; // 알림 서비스

	// 상세페이지에서 주문하기 눌렀을 때 선택 페이지 보여주기

	@GetMapping("/order/select")
	public String selectOrder(@RequestParam("productNo") int productNo, Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		ProductDetailDto product = productService.findProductDetail(productNo);

		// 본인 상품 차단
		if (loginUser.getUserNo() == product.getSellerNo()) {
			return "redirect:/product/" + productNo + "?error=self";
		}

		// 이미 거래중이거나 완료된 상품 차단
		if (!"판매중".equals(product.getTradeStatus())) {
			return "redirect:/product/" + productNo + "?error=unavailable";
		}

		model.addAttribute("product", product);
		return "orderSelect";
	}

	// 동네 인증 페이지
	@GetMapping("/location-auth")
	public String locationAuth(@RequestParam("productNo") int productNo, Model model) {
		model.addAttribute("productNo", productNo);
		return "locationAuth";
	}

	// 동네 인증 완료
	@RequestMapping(value = "/location-auth/check", method = { RequestMethod.GET, RequestMethod.POST })
	public String checkLocation(@RequestParam("productNo") int productNo, @RequestParam("lat") double userLat,
			@RequestParam("lng") double userLng, HttpSession session, Model model) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		ProductDetailDto product = productService.findProductDetail(productNo);
		User seller = userService.getUserByNo(product.getSellerNo());

		double sellerLat = seller.getLatitude();
		double sellerLng = seller.getLongitude();
		double distanceDiff = Math.sqrt(Math.pow(userLat - sellerLat, 2) + Math.pow(userLng - sellerLng, 2));
		boolean verified = distanceDiff <= 0.035;

		model.addAttribute("product", product);
		model.addAttribute("seller", seller);
		model.addAttribute("verified", verified);

		return "locationResult";
	}

	// 직거래 약속(장소·시간·메시지) 입력 폼
	@GetMapping("/order/direct/form")
	public String directForm(@RequestParam("productNo") int productNo, Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		ProductDetailDto product = productService.findProductDetail(productNo);
		if (loginUser.getUserNo() == product.getSellerNo()) {
			return "redirect:/product/" + productNo + "?error=self";
		}
		if (!"판매중".equals(product.getTradeStatus())) {
			return "redirect:/product/" + productNo + "?error=unavailable";
		}

		model.addAttribute("product", product);
		return "orderDirect";
	}

	// 직거래 약속 제출 → 동네인증은 이미 통과한 상태. 예약 생성 후 예약 완료 페이지로
	@PostMapping("/order/direct/submit")
	public String directSubmit(@RequestParam("productNo") int productNo,
			@RequestParam("meetingPlace") String meetingPlace, @RequestParam("meetingTime") String meetingTime,
			@RequestParam(value = "buyerMessage", required = false) String buyerMessage, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		Order order = new Order();
		order.setProductNo(productNo);
		order.setBuyerNo(loginUser.getUserNo());
		order.setTradeType("DIRECT");
		order.setMeetingPlace(meetingPlace);
		order.setBuyerMessage(buyerMessage);
		if (meetingTime != null && !meetingTime.isEmpty()) {
			// "yyyy-MM-ddTHH:mm" → Timestamp
			order.setMeetingTime(Timestamp.valueOf(meetingTime.replace("T", " ") + ":00"));
		}

		int orderNo;
		try {
			orderNo = orderService.reserveDirectOrder(order);
		} catch (IllegalStateException e) {
			return "redirect:/product/" + productNo + "?error=unavailable";
		}

		// 판매자에게 직거래 예약 알림
		try {
			ProductDetailDto product = productService.findProductDetail(productNo);
			notificationService.notifyDirectReserved(order.getSellerNo(), loginUser.getUserNo(), productNo,
					product.getProductName(), loginUser.getUserNickName());
		} catch (Exception e) {
			System.out.println("직거래 예약 알림 발송 실패: " + e.getMessage());
		}

		return "redirect:/order/direct/reserved/" + orderNo;
	}

	// 직거래 예약 완료 페이지 (구매자가 봄)
	@GetMapping("/order/direct/reserved/{orderNo}")
	public String directReservedPage(@PathVariable("orderNo") int orderNo, Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		Order order = orderService.findByOrderNo(orderNo);
		if (order == null || order.getBuyerNo() != loginUser.getUserNo()) {
			return "redirect:/home";
		}

		ProductDetailDto product = productService.findProductDetail(order.getProductNo());
		User seller = userService.getUserByNo(order.getSellerNo());

		model.addAttribute("order", order);
		model.addAttribute("product", product);
		model.addAttribute("seller", seller);
		return "orderReserved";
	}

	// 판매자가 직거래 약속 취소 - 상품을 판매중으로 복원하고 대기자에게 알림
	@PostMapping("/order/direct/{orderNo}/cancel")
	public String sellerCancelDirect(@PathVariable("orderNo") int orderNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		boolean ok = orderService.cancelDirectOrder(orderNo, loginUser.getUserNo());
		if (!ok) {
			return "redirect:/order/pending?error=cannot-cancel";
		}
		return "redirect:/order/pending?cancelled=" + orderNo;
	}

	// 판매자가 직거래 거래완료 버튼 클릭
	@PostMapping("/order/direct/{orderNo}/complete")
	public String sellerCompleteDirect(@PathVariable("orderNo") int orderNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		boolean ok = orderService.completeDirectOrder(orderNo, loginUser.getUserNo());
		if (!ok) {
			return "redirect:/order/pending?error=cannot-confirm";
		}

		try {
			Order order = orderService.findByOrderNo(orderNo);
			ProductDetailDto product = productService.findProductDetail(order.getProductNo());
			notificationService.notifySold(order.getSellerNo(), order.getProductNo(), product.getProductName());
			notificationService.notifyBought(order.getBuyerNo(), order.getProductNo(), product.getProductName());
		} catch (Exception e) {
			System.out.println("직거래 완료 알림 발송 실패: " + e.getMessage());
		}

		return "redirect:/order/pending?completed=" + orderNo;
	}

	// 완료 페이지
	@GetMapping("/complete")
	public String completePage(@RequestParam("productNo") int productNo, HttpSession session, Model model) {

		ProductDetailDto product = productService.findProductDetail(productNo);
		User loginUser = (User) session.getAttribute("loginUser");

		boolean alreadyReviewed = false;
		if (loginUser != null) {
			alreadyReviewed = reviewService.existsReview(productNo, loginUser.getUserNo());
		}

		model.addAttribute("product", product);
		model.addAttribute("loginUser", loginUser);
		model.addAttribute("alreadyReviewed", alreadyReviewed);

		return "orderComplete";
	}

	@PostMapping("/order/route")
	public String routeOrder(@RequestParam("productNo") int productNo, @RequestParam("type") String type,
			HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		if ("DIRECT".equals(type)) {
			// 직거래는 동네인증 먼저 진행 (인증 후 locationResult에서 약속 입력으로 이동)
			if (loginUser.getLatitude() != null && loginUser.getLongitude() != null) {
				return "redirect:/location-auth/check?productNo=" + productNo + "&lat=" + loginUser.getLatitude()
						+ "&lng=" + loginUser.getLongitude();
			}
			return "redirect:/location-auth?productNo=" + productNo;
		}

		if ("TRANSFER".equals(type)) {
			return "redirect:/order/transfer/request/" + productNo;
		}

		return "redirect:/";
	}

	// 계좌 등록 요청 (구매자가 판매자에게 알림 발송)
	@PostMapping("/account/request")
	public String requestAccount(@RequestParam("productNo") int productNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		ProductDetailDto product = productService.findProductDetail(productNo);
		if (product == null) {
			return "redirect:/home";
		}
		try {
			notificationService.notifyAccountRequest(product.getSellerNo(), loginUser.getUserNo(), productNo,
					product.getProductName(), loginUser.getUserNickName());
		} catch (Exception e) {
			System.out.println("계좌 등록 요청 알림 실패: " + e.getMessage());
		}
		return "redirect:/product/" + productNo + "?accountRequest=sent";
	}

	// 계좌이체 거래 요청 페이지
	@GetMapping("/order/transfer/request/{productNo}")
	public String transferRequestPage(@PathVariable("productNo") int productNo, Model model, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null)
			return "redirect:/login";

		ProductDetailDto product = productService.findProductDetail(productNo);

		if (loginUser.getUserNo() == product.getSellerNo()) {
			return "redirect:/product/" + productNo + "?error=self";
		}

		if (!"판매중".equals(product.getTradeStatus())) {
			return "redirect:/product/" + productNo + "?error=unavailable";
		}

		model.addAttribute("product", product);

		return "tradeRequest";
	}

	// 거래 요청 보내기 — orders insert(status='요청') + 판매자에게 알림
	@PostMapping("/order/transfer/request")
	public String sendTransferRequest(@RequestParam("productNo") int productNo, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		ProductDetailDto product = productService.findProductDetail(productNo);

		try {
			orderService.createTransferRequest(productNo, loginUser.getUserNo());
		} catch (IllegalStateException e) {
			String msg = e.getMessage();
			if (msg != null && msg.contains("이미 진행 중")) {
				// 동일 구매자가 같은 상품에 이미 요청을 보낸 상태 — 알림 발송 없이 안내
				return "redirect:/product/" + productNo + "?error=already-requested";
			}
			return "redirect:/product/" + productNo + "?error=unavailable";
		}

		try {
			notificationService.notifyTransferRequest(product.getSellerNo(), loginUser.getUserNo(), productNo,
					product.getProductName(), loginUser.getUserNickName());
		} catch (Exception e) {
			System.out.println("거래 요청 알림 실패 : " + e.getMessage());
		}

		return "redirect:/product/" + productNo + "?transferRequested=1";
	}

	// 계좌이체 폼 화면
	@GetMapping("/order/transfer/form")
	public String transferForm(@RequestParam("productNo") int productNo, Model model, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/login";
		}

		ProductDetailDto product = productService.findProductDetail(productNo);

		// 본인 상품 차단
		if (loginUser.getUserNo() == product.getSellerNo()) {
			return "redirect:/product/" + productNo + "?error=self";
		}

		// 이미 거래 완료된 상품은 차단
		if ("완료".equals(product.getTradeStatus())) {
			return "redirect:/product/" + productNo + "?error=unavailable";
		}

		// 거래 요청 + 판매자 승인 확인
		// (승인된 본인은 product가 '예약중'이어도 폼 진입 가능)
		Order order = orderService.findByProductAndBuyer(productNo, loginUser.getUserNo());

		if (order == null || !"승인완료".equals(order.getOrderStatus())) {
			return "redirect:/product/" + productNo + "?error=not-approved";
		}

		User seller = userService.getUserByNo(product.getSellerNo());

		model.addAttribute("product", product);

		model.addAttribute("seller", seller);

		model.addAttribute("loginUser", loginUser);

		return "orderTransfer";
	}

	@PostMapping("/order/transfer/request-submit")
	public String transferRequestSubmit(@RequestParam("productNo") int productNo, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		ProductDetailDto product = productService.findProductDetail(productNo);

		notificationService.notifyTransferRequest(product.getSellerNo(), loginUser.getUserNo(), productNo,
				product.getProductName(), loginUser.getUserNickName());

		return "redirect:/product/" + productNo + "?request=sent";
	}

	@GetMapping("/order/pending-request/{productNo}")
	public String pendingRequest(@PathVariable int productNo, Model model, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null)
			return "redirect:/login";

		ProductDetailDto product = productService.findProductDetail(productNo);

		if (product.getSellerNo() != loginUser.getUserNo()) {
			return "redirect:/home";
		}

		model.addAttribute("product", product);

		return "orderRequestApprove";
	}

	// 판매자가 거래 요청 승인 — 트랜잭션으로 중복 승인 방지
	@PostMapping("/order/transfer/{orderNo}/approve")
	public String approveTransfer(@PathVariable("orderNo") int orderNo, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		boolean ok = orderService.approveTransfer(orderNo, loginUser.getUserNo());
		if (!ok) {
			// 이미 다른 거래가 진행중이거나 권한 없음/이미 처리됨
			return "redirect:/order/pending?error=cannot-approve";
		}

		// 승인 성공 시 구매자에게 승인 알림
		try {
			Order order = orderService.findByOrderNo(orderNo);
			ProductDetailDto product = productService.findProductDetail(order.getProductNo());
			notificationService.notifyTransferApproved(order.getBuyerNo(), loginUser.getUserNo(), order.getProductNo(),
					product.getProductName());
		} catch (Exception e) {
			System.out.println("거래 승인 알림 발송 실패: " + e.getMessage());
		}

		return "redirect:/order/pending?approved=" + orderNo;
	}

	// 계좌이체 거래 취소 — 판매자/구매자 본인 입금완료 이후는 차단됨
	@PostMapping("/order/transfer/{orderNo}/cancel")
	public String cancelTransfer(@PathVariable("orderNo") int orderNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		boolean ok = orderService.cancelTransferOrder(orderNo, loginUser.getUserNo());
		if (!ok) {
			return "redirect:/order/pending?error=cannot-cancel-transfer";
		}
		return "redirect:/order/pending?transferCancelled=" + orderNo;
	}

	// 계좌이체 주문 생성 (알림은 구매자가 송금 완료 버튼을 눌러야 발송)
	@PostMapping("/order/transfer-submit")
	public String transferSubmit(@ModelAttribute Order order, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		order.setBuyerNo(loginUser.getUserNo());
		int orderNo = orderService.createTransferOrder(order);

		return "redirect:/order/waiting/" + orderNo;
	}

	// 구매자가 송금 완료 -> 판매자에게 입금 확인 요청 알림
	@PostMapping("/order/{orderNo}/notify-deposit")
	public String notifyDepositDone(@PathVariable("orderNo") int orderNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		Order order = orderService.findByOrderNo(orderNo);
		if (order == null || order.getBuyerNo() != loginUser.getUserNo()) {
			return "redirect:/home";
		}
		if (!"입금대기".equals(order.getOrderStatus())) {
			// 이미 처리된 주문이면 그냥 대기 페이지로
			return "redirect:/order/waiting/" + orderNo;
		}

		try {
			ProductDetailDto product = productService.findProductDetail(order.getProductNo());
			notificationService.notifyDepositPending(order.getSellerNo(), loginUser.getUserNo(), order.getProductNo(),
					product.getProductName(), loginUser.getUserNickName());
		} catch (Exception e) {
			System.out.println("입금 완료 알림 발송 실패: " + e.getMessage());
		}

		return "redirect:/order/waiting/" + orderNo + "?notified=1";
	}

	// 입금 대기 안내 페이지 (구매자가 봄)
	@GetMapping("/order/waiting/{orderNo}")
	public String waitingPage(@PathVariable("orderNo") int orderNo, Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		Order order = orderService.findByOrderNo(orderNo);
		if (order == null)
			return "redirect:/home";

		// 본인 주문만 접근 가능
		if (order.getBuyerNo() != loginUser.getUserNo()) {
			return "redirect:/home";
		}

		ProductDetailDto product = productService.findProductDetail(order.getProductNo());
		User seller = userService.getUserByNo(order.getSellerNo());

		model.addAttribute("order", order);
		model.addAttribute("product", product);
		model.addAttribute("seller", seller);
		return "orderWaiting";
	}

	// 판매자가 입금 확인 -> 거래 완료까지 진행
	@PostMapping("/order/{orderNo}/confirm-payment")
	public String confirmPayment(@PathVariable("orderNo") int orderNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		// DB 상태 변경 및 카운트 증가 처리
		boolean ok = orderService.confirmPayment(orderNo, loginUser.getUserNo());
		if (!ok) {
			return "redirect:/accountList?error=cannot-confirm";
		}

		try {
			Order order = orderService.findByOrderNo(orderNo);
			ProductDetailDto product = productService.findProductDetail(order.getProductNo());

			// 판매자에게 완료 알림
			notificationService.notifySold(order.getSellerNo(), order.getProductNo(), product.getProductName());
			// 구매자에게 완료 알림
			notificationService.notifyBought(order.getBuyerNo(), order.getProductNo(), product.getProductName());
		} catch (Exception e) {
			System.out.println("거래완료 알림 발송 실패: " + e.getMessage());
		}

		return "redirect:/order/pending?confirmed=" + orderNo;
	}

	// 판매자 - 거래 요청 대기 + 입금 확인 대기 + 직거래 예약 목록
	@GetMapping("/order/pending")
	public String pendingOrders(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		List<Order> transferRequests = orderService.findTransferRequestsBySeller(loginUser.getUserNo());
		List<Order> pendingTransfers = orderService.findPendingTransfersBySeller(loginUser.getUserNo());
		List<Order> reservedDirects = orderService.findReservedDirectsBySeller(loginUser.getUserNo());

		model.addAttribute("transferRequests", transferRequests);
		model.addAttribute("pendingTransfers", pendingTransfers);
		model.addAttribute("reservedDirects", reservedDirects);

		return "orderPending";
	}
}