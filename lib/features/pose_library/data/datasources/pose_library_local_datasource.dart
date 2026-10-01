import '../../domain/entities/pose_library_item.dart';
import '../../domain/entities/pose_tip.dart';

/// ============================================================================
/// LOCAL DATA SOURCE — Dữ liệu tĩnh cho Thư Viện Dáng Chụp
/// Phân loại đa chiều:
///   - category: Nữ, Nam, Cặp đôi, Nhóm
///   - context:  Du lịch biển, Cafe/Quán ăn, Đường phố, Công sở, Áo dài, Studio, Ngoài trời
///   - poseType: Dáng đứng, Dáng ngồi, Dáng đi/Chuyển động, Chân dung, Phụ kiện
/// ============================================================================
class PoseLibraryLocalDatasource {
  // --------------------------------------------------------------------------
  // TIPS TOÀN CỤC (20 tips phân theo 5 nhóm)
  // --------------------------------------------------------------------------
  static List<PoseTip> get allTips => [
        // --- Góc chụp ---
        const PoseTip(
          id: 'tip_angle_01',
          category: 'Góc chụp',
          icon: '📐',
          title: 'Góc thấp tôn chiều cao',
          description:
              'Đặt máy ảnh ngang hông hoặc thấp hơn, hướng lên trên để tạo hiệu ứng chân dài và vóc dáng thanh thoát hơn.',
        ),
        const PoseTip(
          id: 'tip_angle_02',
          category: 'Góc chụp',
          icon: '🔭',
          title: 'Rule of Thirds',
          description:
              'Đặt chủ thể tại 1/3 trái hoặc phải khung hình thay vì chính giữa để tạo bố cục cân bằng và thú vị hơn.',
        ),
        const PoseTip(
          id: 'tip_angle_03',
          category: 'Góc chụp',
          icon: '🌀',
          title: 'Góc chụp nghiêng Dutch',
          description:
              'Nghiêng máy ảnh nhẹ 5–15° để tạo cảm giác năng động, phù hợp với ảnh street style và editorial.',
        ),
        const PoseTip(
          id: 'tip_angle_04',
          category: 'Góc chụp',
          icon: '🏔️',
          title: 'Góc từ trên cao',
          description:
              'Chụp từ trên cao nhìn xuống giúp mặt trông nhỏ hơn và mắt to hơn — rất phổ biến trong chụp selfie và ảnh cafe.',
        ),
        // --- Ngôn ngữ cơ thể ---
        const PoseTip(
          id: 'tip_body_01',
          category: 'Ngôn ngữ cơ thể',
          icon: '💃',
          title: 'Chuyển trọng lực sang 1 chân',
          description:
              'Dồn trọng lượng lên một chân, hông nhẹ nhàng nghiêng — dáng S-curve tạo đường cong tự nhiên và gợi cảm.',
        ),
        const PoseTip(
          id: 'tip_body_02',
          category: 'Ngôn ngữ cơ thể',
          icon: '🤚',
          title: 'Tay không được thả lỏng hoàn toàn',
          description:
              'Tránh để hai tay dọc theo thân mình — thay vào đó đặt lên eo, túi hoặc chạm nhẹ vào mặt cho tự nhiên hơn.',
        ),
        const PoseTip(
          id: 'tip_body_03',
          category: 'Ngôn ngữ cơ thể',
          icon: '🧍',
          title: 'Mở vai, không khom lưng',
          description:
              'Giữ vai mở ra, ngực hơi ưỡn nhẹ và lưng thẳng. Tư thế đứng tự tin sẽ tạo ra ảnh chuyên nghiệp ngay lập tức.',
        ),
        const PoseTip(
          id: 'tip_body_04',
          category: 'Ngôn ngữ cơ thể',
          icon: '👣',
          title: 'Đặt chân đúng cách',
          description:
              'Tránh đứng hai chân song song — hãy bước một chân ra trước hoặc bắt chéo nhẹ để tạo đường cong tự nhiên cho cơ thể.',
        ),
        const PoseTip(
          id: 'tip_body_05',
          category: 'Ngôn ngữ cơ thể',
          icon: '🪞',
          title: 'Thả lỏng vai trước khi chụp',
          description:
              'Nâng vai lên cao rồi thả xuống mạnh trước khi chụp — động tác này giúp vai về vị trí tự nhiên nhất, tránh bị "cứng".',
        ),
        // --- Ánh sáng ---
        const PoseTip(
          id: 'tip_light_01',
          category: 'Ánh sáng',
          icon: '☀️',
          title: 'Golden Hour — Giờ vàng',
          description:
              'Chụp vào 1 giờ sau bình minh hoặc 1 giờ trước hoàng hôn. Ánh sáng ấm, mềm và tôn da vô cùng hiệu quả.',
        ),
        const PoseTip(
          id: 'tip_light_02',
          category: 'Ánh sáng',
          icon: '🪟',
          title: 'Ánh sáng cửa sổ tự nhiên',
          description:
              'Đứng cạnh cửa sổ lớn, mặt hướng về phía ánh sáng chiếu vào. Hiệu ứng Rembrandt lighting tạo chiều sâu cho khuôn mặt.',
        ),
        const PoseTip(
          id: 'tip_light_03',
          category: 'Ánh sáng',
          icon: '🌤️',
          title: 'Tránh ánh nắng trực tiếp',
          description:
              'Chụp trong bóng râm hoặc ngày nhiều mây để ánh sáng mềm mại đều khắp, tránh bóng đổ xấu trên mặt.',
        ),
        const PoseTip(
          id: 'tip_light_04',
          category: 'Ánh sáng',
          icon: '🏙️',
          title: 'Ánh đèn neon về đêm',
          description:
              'Tìm kiếm các biển đèn LED, neon để tạo ánh sáng màu sắc độc đáo. Đứng gần nguồn sáng và chụp manual với ISO thấp.',
        ),
        // --- Biểu cảm ---
        const PoseTip(
          id: 'tip_expr_01',
          category: 'Biểu cảm',
          icon: '😊',
          title: 'Mỉm cười bằng mắt — Smize',
          description:
              'Nheo nhẹ đuôi mắt khi cười — ánh mắt ấm áp và tự nhiên hơn nhiều so với chỉ cười bằng miệng.',
        ),
        const PoseTip(
          id: 'tip_expr_02',
          category: 'Biểu cảm',
          icon: '🎭',
          title: 'Thư giãn khuôn mặt trước khi chụp',
          description:
              'Hít thở sâu, thả lỏng cơ mặt, sau đó mới lên biểu cảm. Tránh căng thẳng khiến ảnh trông cứng nhắc.',
        ),
        const PoseTip(
          id: 'tip_expr_03',
          category: 'Biểu cảm',
          icon: '👁️',
          title: 'Ánh mắt quyết định cảm xúc',
          description:
              'Nhìn thẳng vào ống kính cho sự tự tin, nhìn sang một bên tạo cảm giác mơ màng, nhìn xuống tạo vẻ dịu dàng — chọn phù hợp với concept.',
        ),
        // --- Trang phục & Phụ kiện ---
        const PoseTip(
          id: 'tip_outfit_01',
          category: 'Trang phục',
          icon: '👗',
          title: 'Màu sắc tương phản với phông nền',
          description:
              'Chọn trang phục có màu tương phản với nền chụp (ví dụ: áo trắng trên nền xanh lá) để chủ thể nổi bật hơn.',
        ),
        const PoseTip(
          id: 'tip_outfit_02',
          category: 'Trang phục',
          icon: '👠',
          title: 'Giày cao gót tôn dáng',
          description:
              'Trong ảnh toàn thân, giày cao gót kéo dài chân đáng kể — kết hợp với góc chụp thấp để tối ưu hiệu quả.',
        ),
        const PoseTip(
          id: 'tip_outfit_03',
          category: 'Trang phục',
          icon: '🧣',
          title: 'Phụ kiện tạo điểm nhấn',
          description:
              'Mũ, kính, khăn hoặc túi xách tạo thêm câu chuyện cho bức ảnh và giúp tay bạn có chỗ để đặt tự nhiên.',
        ),
        const PoseTip(
          id: 'tip_outfit_04',
          category: 'Trang phục',
          icon: '☕',
          title: 'Prop cốc cafe & đồ uống',
          description:
              'Cầm cốc cafe, ly nước hoặc bó hoa giúp tay không bị "thừa" trong ảnh, tạo câu chuyện sống động và authentic.',
        ),
      ];

  // --------------------------------------------------------------------------
  // TẤT CẢ DÁNG CHỤP (40+ dáng đa phân loại)
  // --------------------------------------------------------------------------
  static List<PoseLibraryItem> get allPoses => [
        // ====================================================================
        // DANH MỤC: NỮ
        // ====================================================================

        // --- NỮ · Dáng đứng · Đường phố ---
        PoseLibraryItem(
          id: 'f_stand_street_01',
          title: 'S-Curve Quyến Rũ',
          category: 'Nữ',
          context: 'Đường phố',
          poseType: 'Dáng đứng',
          difficulty: 'Trung bình',
          imageUrl:
              'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=600&auto=format&fit=crop&q=80',
          description:
              'Đường cong S tự nhiên của cơ thể được tạo ra khi dồn trọng lượng lên một chân và để hông tự nghiêng. Rất được ưa chuộng trong ảnh portrait nữ đường phố.',
          steps: [
            'Dồn hoàn toàn trọng lượng lên chân phải',
            'Hông tự nhiên nghiêng sang phải',
            'Vai trái nhẹ nhàng hạ xuống',
            'Tay phải đặt lên eo, tay trái thả xuôi theo người',
            'Hơi xoay 3/4 người về phía máy ảnh',
            'Ánh mắt nhìn ra xa hoặc nhìn thẳng vào ống kính',
          ],
          isHot: true,
          isNew: false,
          tips: [
            const PoseTip(
              id: 'tip_scurve_a',
              category: 'Ngôn ngữ cơ thể',
              icon: '💃',
              title: 'Hông là chìa khóa',
              description:
                  'Càng dồn trọng lượng sang một bên nhiều, đường cong S càng rõ ràng. Luyện tập trước gương để cảm nhận tư thế tự nhiên.',
            ),
            const PoseTip(
              id: 'tip_scurve_b',
              category: 'Góc chụp',
              icon: '📐',
              title: 'Chụp góc 3/4',
              description:
                  'Góc chụp 3/4 kết hợp S-curve sẽ tạo ra hiệu ứng đường cong đẹp nhất. Tránh chụp thẳng từ phía trước.',
            ),
          ],
        ),

        // --- NỮ · Dáng đứng · Ngoài trời ---
        PoseLibraryItem(
          id: 'f_stand_outdoor_01',
          title: 'Dáng Đứng Tự Tin',
          category: 'Nữ',
          context: 'Ngoài trời',
          poseType: 'Dáng đứng',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600&auto=format&fit=crop&q=80',
          description:
              'Dáng đứng thẳng với một chân nhẹ nhàng bước ra phía trước, hai tay đặt thoải mái. Phù hợp cho mọi hoàn cảnh từ ngoài trời đến studio.',
          steps: [
            'Đứng thẳng, dồn trọng lượng lên chân phải',
            'Bước chân trái nhẹ ra phía trước khoảng 20–30cm',
            'Hơi xoay vai trái về phía máy ảnh',
            'Đặt tay trái lên eo, tay phải thả tự nhiên',
            'Cằm hơi ngẩng lên, mắt nhìn thẳng vào ống kính',
          ],
          isHot: true,
          tips: [
            const PoseTip(
              id: 'tip_f_stand_a',
              category: 'Ngôn ngữ cơ thể',
              icon: '🦵',
              title: 'Chân trước hơi uốn cong',
              description:
                  'Uốn cong nhẹ đầu gối chân trước để dáng đứng trông mềm mại và tự nhiên hơn thay vì cứng đơ.',
            ),
          ],
        ),

        // --- NỮ · Dáng đứng · Tựa lưng ---
        PoseLibraryItem(
          id: 'f_stand_lean_01',
          title: 'Tựa Lưng Vào Tường',
          category: 'Nữ',
          context: 'Đường phố',
          poseType: 'Dáng đứng',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600&auto=format&fit=crop&q=80',
          description:
              'Tựa nhẹ vào tường tạo sự thoải mái và tự tin. Dáng cực kỳ phổ biến và dễ thực hiện với mọi vóc dáng.',
          steps: [
            'Đứng cạnh tường, tựa vai hoặc cả lưng nhẹ vào tường',
            'Một chân chống lên tường, chân kia duỗi thẳng',
            'Tay đặt trong túi quần hoặc chéo trước ngực',
            'Nhìn thẳng vào máy hoặc nhìn sang một hướng',
            'Thể hiện vẻ thư thái, casual',
          ],
          tips: [],
        ),

        // --- NỮ · Dáng ngồi · Cafe ---
        PoseLibraryItem(
          id: 'f_sit_cafe_01',
          title: 'Ngồi Cafe Thư Giãn',
          category: 'Nữ',
          context: 'Cafe/Quán ăn',
          poseType: 'Dáng ngồi',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=600&auto=format&fit=crop&q=80',
          description:
              'Ngồi thoải mái tại quán cafe với cốc nước trên tay hoặc trên bàn. Tạo không khí ấm cúng và authentic cho ảnh lifestyle.',
          steps: [
            'Ngồi thẳng lưng trên ghế, không khom người',
            'Đặt cốc cafe lên bàn hoặc cầm nhẹ bằng cả hai tay',
            'Nghiêng người nhẹ về phía trước, tạo cảm giác thư thái',
            'Nhìn vào cốc cafe hoặc nhìn ra cửa sổ',
            'Để ánh sáng tự nhiên từ cửa sổ chiếu vào mặt',
          ],
          isNew: true,
          tips: [
            const PoseTip(
              id: 'tip_cafe_a',
              category: 'Trang phục',
              icon: '☕',
              title: 'Prop cốc cafe & đồ uống',
              description:
                  'Cầm cốc cafe giúp tay không bị "thừa" trong ảnh, tạo câu chuyện sống động và authentic.',
            ),
            const PoseTip(
              id: 'tip_cafe_b',
              category: 'Ánh sáng',
              icon: '🪟',
              title: 'Ánh sáng cửa sổ tự nhiên',
              description:
                  'Ngồi gần cửa sổ và để ánh sáng chiếu từ một bên — tạo hiệu ứng rembrandt lighting tuyệt đẹp.',
            ),
          ],
        ),

        // --- NỮ · Chân dung · Studio ---
        PoseLibraryItem(
          id: 'f_portrait_studio_01',
          title: 'Chân Dung 3/4 Mặt',
          category: 'Nữ',
          context: 'Studio',
          poseType: 'Chân dung',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=600&auto=format&fit=crop&q=80',
          description:
              'Xoay mặt nhẹ 3/4 về phía máy ảnh, không nhìn thẳng. Góc này tôn đường nét khuôn mặt và tạo chiều sâu cho ảnh chân dung.',
          steps: [
            'Xoay đầu nhẹ sang phải hoặc trái khoảng 30–45°',
            'Mắt nhìn thẳng vào ống kính',
            'Cằm hơi hướng về phía ống kính',
            'Thả lỏng vai và cổ',
            'Chụp close-up hoặc bán thân',
          ],
          isHot: true,
          tips: [
            const PoseTip(
              id: 'tip_portrait_a',
              category: 'Biểu cảm',
              icon: '👁️',
              title: 'Ánh mắt quyết định cảm xúc',
              description:
                  'Nhìn thẳng vào ống kính cho sự tự tin, nhìn sang một bên tạo cảm giác mơ màng.',
            ),
          ],
        ),

        // --- NỮ · Chân dung · Tay chạm mặt ---
        PoseLibraryItem(
          id: 'f_portrait_touch_01',
          title: 'Tay Chạm Nhẹ Vào Mặt',
          category: 'Nữ',
          context: 'Studio',
          poseType: 'Chân dung',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=600&auto=format&fit=crop&q=80',
          description:
              'Đặt nhẹ một hoặc hai ngón tay lên gò má, cằm hoặc thái dương. Tạo cảm giác suy nghĩ, bí ẩn và tinh tế.',
          steps: [
            'Đặt ngón tay cái dưới cằm, ngón trỏ chạm nhẹ lên má',
            'Hoặc áp má vào lòng bàn tay',
            'Khuỷu tay chống nhẹ nếu có bàn',
            'Nhìn thẳng vào ống kính với ánh mắt sâu thẳm',
          ],
          isNew: true,
          tips: [],
        ),

        // --- NỮ · Phụ kiện · Túi xách ---
        PoseLibraryItem(
          id: 'f_accessory_bag_01',
          title: 'Xách Túi Dạo Phố',
          category: 'Nữ',
          context: 'Đường phố',
          poseType: 'Phụ kiện',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=600&auto=format&fit=crop&q=80',
          description:
              'Cầm hoặc xách túi xách theo nhiều cách khác nhau để tạo điểm nhấn thời trang. Túi xách là phụ kiện quan trọng giúp tay không "thừa".',
          steps: [
            'Cầm quai túi bằng ngón tay hoặc đặt lên vai',
            'Bước đi hoặc dừng lại tự nhiên',
            'Tay còn lại có thể đặt vào túi quần hoặc thả tự nhiên',
            'Nhìn về phía trước như đang đi mua sắm',
          ],
          isHot: true,
          tips: [],
        ),

        // --- NỮ · Áo dài ---
        PoseLibraryItem(
          id: 'f_aodai_01',
          title: 'Áo Dài Bay Trong Gió',
          category: 'Nữ',
          context: 'Áo dài',
          poseType: 'Dáng đứng',
          difficulty: 'Trung bình',
          imageUrl:
              'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=600&auto=format&fit=crop&q=80',
          description:
              'Để tà áo dài bay nhẹ trong gió hoặc tay nhẹ nhàng giữ tà áo. Kết hợp với nón lá truyền thống tạo nét đẹp dịu dàng và thuần Việt.',
          steps: [
            'Mặc áo dài và đội nón lá (hoặc không)',
            'Đứng nơi có gió nhẹ để tà áo bay tự nhiên',
            'Hoặc dùng tay nhẹ nhàng cầm tà áo giơ lên',
            'Bước đi thong thả hoặc xoay người nhẹ nhàng',
            'Nghiêng đầu nhẹ và mỉm cười dịu dàng',
          ],
          isHot: true,
          isNew: true,
          tips: [
            const PoseTip(
              id: 'tip_aodai_a',
              category: 'Trang phục',
              icon: '🌸',
              title: 'Chọn nền phù hợp áo dài',
              description:
                  'Nền cổng tam quan, vườn hoa hoặc phố cổ Hội An rất hợp với áo dài. Tránh nền hiện đại sẽ phá vỡ concept.',
            ),
            const PoseTip(
              id: 'tip_aodai_b',
              category: 'Ngôn ngữ cơ thể',
              icon: '🌺',
              title: 'Bước đi duyên dáng',
              description:
                  'Bước từng bước nhỏ, chân không dang rộng, tay giữ tà áo nhẹ nhàng để dáng đi trông thanh thoát.',
            ),
          ],
        ),

        // --- NỮ · Dáng ngồi · Bậc thềm ---
        PoseLibraryItem(
          id: 'f_sit_step_01',
          title: 'Ngồi Trên Bậc Thềm',
          category: 'Nữ',
          context: 'Ngoài trời',
          poseType: 'Dáng ngồi',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=600&auto=format&fit=crop&q=80',
          description:
              'Ngồi thoải mái trên bậc thềm hoặc ghế, tạo cảm giác thân thiện và gần gũi. Rất phù hợp cho ảnh lifestyle ngoài trời.',
          steps: [
            'Ngồi trên bậc thềm, hai chân duỗi thẳng hoặc một chân co lên',
            'Lưng thẳng, vai mở ra',
            'Đặt tay lên đầu gối hoặc ôm nhẹ lấy chân co',
            'Nghiêng đầu nhẹ sang một bên',
            'Mỉm cười tự nhiên',
          ],
          tips: [],
        ),

        // --- NỮ · Dáng đi · Du lịch biển ---
        PoseLibraryItem(
          id: 'f_walk_beach_01',
          title: 'Đi Dạo Trên Biển',
          category: 'Nữ',
          context: 'Du lịch biển',
          poseType: 'Dáng đi/Chuyển động',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=600&auto=format&fit=crop&q=80',
          description:
              'Đi dạo dọc bờ biển với sóng nước và cát trắng phía sau. Một trong những dáng được yêu thích nhất cho ảnh du lịch biển.',
          steps: [
            'Bước đi thong thả dọc bờ biển',
            'Tay cầm dép hoặc thả tự nhiên',
            'Nhìn ra biển hoặc nhìn xuống sóng',
            'Nhiếp ảnh gia chụp từ phía sau hoặc góc ngang',
            'Chụp vào buổi sáng sớm để tránh nắng gắt',
          ],
          isNew: true,
          tips: [
            const PoseTip(
              id: 'tip_beach_a',
              category: 'Ánh sáng',
              icon: '🌅',
              title: 'Chụp lúc bình minh hoặc hoàng hôn',
              description:
                  'Ánh sáng golden hour trên biển cực kỳ đẹp — chụp sớm cũng tránh được đông người trên bãi biển.',
            ),
          ],
        ),

        // --- NỮ · Công sở ---
        PoseLibraryItem(
          id: 'f_office_01',
          title: 'Phong Cách Công Sở Chuyên Nghiệp',
          category: 'Nữ',
          context: 'Công sở',
          poseType: 'Dáng đứng',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600&auto=format&fit=crop&q=80',
          description:
              'Dáng tự tin, chuyên nghiệp cho môi trường văn phòng. Phù hợp chụp ảnh profile LinkedIn, thẻ nhân viên hoặc portfolio.',
          steps: [
            'Đứng thẳng với tư thế tự tin',
            'Tay cầm tài liệu, laptop hoặc đặt trước ngực',
            'Mặc trang phục công sở phù hợp',
            'Chụp trước nền văn phòng hoặc nền trắng',
            'Biểu cảm chuyên nghiệp nhưng thân thiện',
          ],
          tips: [],
        ),

        // ====================================================================
        // DANH MỤC: NAM
        // ====================================================================

        // --- Nam · Dáng đứng · Đường phố ---
        PoseLibraryItem(
          id: 'm_stand_street_01',
          title: 'Tay Trong Túi Quần',
          category: 'Nam',
          context: 'Đường phố',
          poseType: 'Dáng đứng',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1520013817300-1f4c1cb245ef?w=600&auto=format&fit=crop&q=80',
          description:
              'Đặt một hoặc hai tay trong túi quần và nhìn về phía trước. Dáng casual và masculine rất phổ biến cho ảnh streetwear nam.',
          steps: [
            'Đứng thẳng hoặc tựa nhẹ vào tường',
            'Đặt cả hai tay vào túi quần',
            'Nhìn thẳng vào ống kính hoặc nhìn sang ngang',
            'Mở vai, không khom lưng',
            'Biểu cảm lạnh lùng, bí ẩn hoặc thoải mái',
          ],
          isHot: true,
          tips: [
            const PoseTip(
              id: 'tip_m_pocket_a',
              category: 'Ngôn ngữ cơ thể',
              icon: '🧍',
              title: 'Tư thế alpha — vai mở rộng',
              description:
                  'Mở rộng vai ra và đứng thẳng tạo hình ảnh mạnh mẽ, tự tin. Tránh khom lưng hoặc vai xệ.',
            ),
          ],
        ),

        // --- Nam · Dáng đứng · Lean ---
        PoseLibraryItem(
          id: 'm_lean_wall_01',
          title: 'Tựa Tường Cool Ngầu',
          category: 'Nam',
          context: 'Đường phố',
          poseType: 'Dáng đứng',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?w=600&auto=format&fit=crop&q=80',
          description:
              'Tựa lưng hoặc vai vào tường, thể hiện sự thư thái và tự tin. Là một trong những dáng ưa thích nhất của nam giới.',
          steps: [
            'Tựa lưng hoàn toàn vào tường',
            'Chân bắt chéo nhẹ hoặc đặt một chân lên tường',
            'Khoanh tay trước ngực hoặc để tay trong túi',
            'Nhìn thẳng vào máy hoặc nhìn sang ngang',
          ],
          isNew: true,
          tips: [],
        ),

        // --- Nam · Dáng ngồi · Ngoài trời ---
        PoseLibraryItem(
          id: 'm_sit_outdoor_01',
          title: 'Ngồi Thư Thái Ngoài Trời',
          category: 'Nam',
          context: 'Ngoài trời',
          poseType: 'Dáng ngồi',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&auto=format&fit=crop&q=80',
          description:
              'Ngồi thư thái trên băng ghế công viên hoặc bậc thềm. Tạo cảm giác năng động và thoải mái.',
          steps: [
            'Ngồi trên băng ghế hoặc bậc đá',
            'Chống tay lên đùi hoặc đặt hai tay hai bên',
            'Hơi ngả người về phía sau thoải mái',
            'Nhìn ra xa hoặc nhìn vào camera',
          ],
          tips: [],
        ),

        // --- Nam · Dáng đi · Đường phố ---
        PoseLibraryItem(
          id: 'm_walk_street_01',
          title: 'Bước Đi Tự Nhiên Trên Phố',
          category: 'Nam',
          context: 'Đường phố',
          poseType: 'Dáng đi/Chuyển động',
          difficulty: 'Trung bình',
          imageUrl:
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=600&auto=format&fit=crop&q=80',
          description:
              'Bước đi tự nhiên trên phố như đang bị chụp candid. Tạo cảm giác năng động và authentic cho ảnh streetwear.',
          steps: [
            'Bước đi thoải mái, tự nhiên không nhìn vào camera',
            'Đầu hơi thấp hoặc nhìn về phía trước',
            'Cầm điện thoại hoặc cà phê tay mang đi',
            'Nhiếp ảnh gia chụp từ phía trước góc 45°',
            'Chụp burst để chọn bước chân đẹp nhất',
          ],
          isHot: true,
          tips: [],
        ),

        // --- Nam · Chân dung · Studio ---
        PoseLibraryItem(
          id: 'm_portrait_studio_01',
          title: 'Chân Dung Nam Editorial',
          category: 'Nam',
          context: 'Studio',
          poseType: 'Chân dung',
          difficulty: 'Trung bình',
          imageUrl:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600&auto=format&fit=crop&q=80',
          description:
              'Chân dung góc 3/4 với ánh nhìn mạnh mẽ và biểu cảm quyết đoán. Phù hợp cho ảnh profile chuyên nghiệp và editorial.',
          steps: [
            'Xoay mặt 30–45° sang một bên',
            'Cằm hơi hạ xuống, không ngẩng lên',
            'Ánh mắt nhìn thẳng hoặc hơi nhìn lên lens',
            'Thả lỏng cơ hàm, không căng thẳng',
            'Chụp với ánh sáng từ một bên để tạo chiều sâu',
          ],
          isNew: true,
          tips: [],
        ),

        // --- Nam · Phụ kiện · Kính ---
        PoseLibraryItem(
          id: 'm_accessory_sunglasses_01',
          title: 'Đeo Kính Mát Phong Cách',
          category: 'Nam',
          context: 'Đường phố',
          poseType: 'Phụ kiện',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=600&auto=format&fit=crop&q=80',
          description:
              'Đeo kính mát với nhiều cách khác nhau — nhìn thẳng, nhìn từ trên kính xuống, hoặc tay cầm kính — tạo phong cách riêng.',
          steps: [
            'Đeo kính mát bình thường và nhìn thẳng vào camera',
            'Hoặc hạ kính xuống một chút, nhìn từ trên kính',
            'Hoặc cầm kính bằng một tay, nhìn thẳng',
            'Tay còn lại thả tự nhiên hoặc chạm nhẹ vào cằm',
          ],
          tips: [],
        ),

        // --- Nam · Công sở ---
        PoseLibraryItem(
          id: 'm_office_01',
          title: 'Dáng Công Sở Nam Tự Tin',
          category: 'Nam',
          context: 'Công sở',
          poseType: 'Dáng đứng',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=600&auto=format&fit=crop&q=80',
          description:
              'Đứng tự tin trong môi trường công sở, tay cầm tài liệu hoặc khoanh tay. Phù hợp cho ảnh profile LinkedIn và thẻ nhân viên.',
          steps: [
            'Đứng thẳng, vai mở',
            'Khoanh tay trước ngực hoặc một tay trong túi, tay kia cầm tài liệu',
            'Mặc vest hoặc áo sơ mi công sở',
            'Chụp trước nền văn phòng hoặc nền tường trơn',
            'Biểu cảm tự tin và thân thiện',
          ],
          isHot: true,
          tips: [],
        ),

        // ====================================================================
        // DANH MỤC: CẶP ĐÔI
        // ====================================================================

        // --- Cặp đôi · Ôm từ phía sau ---
        PoseLibraryItem(
          id: 'c_hug_back_01',
          title: 'Ôm Từ Phía Sau',
          category: 'Cặp đôi',
          context: 'Ngoài trời',
          poseType: 'Dáng đứng',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=600&auto=format&fit=crop&q=80',
          description:
              'Một người ôm từ phía sau và đặt cằm lên vai người kia. Thể hiện sự gắn kết và ấm áp giữa hai người.',
          steps: [
            'Người phía sau đứng sát và ôm vòng qua eo người trước',
            'Đặt cằm lên vai người trước',
            'Người phía trước có thể đặt tay lên tay người ôm mình',
            'Cả hai cùng nhìn vào ống kính hoặc nhìn sang cùng một hướng',
            'Mỉm cười tự nhiên và thoải mái',
          ],
          isHot: true,
          tips: [
            const PoseTip(
              id: 'tip_hug_a',
              category: 'Góc chụp',
              icon: '📐',
              title: 'Chụp góc ngang hoặc hơi cao',
              description:
                  'Với dáng ôm từ phía sau, chụp ngang tầm mắt hoặc từ trên cao một chút sẽ thấy được cả hai mặt người trong ảnh.',
            ),
          ],
        ),

        // --- Cặp đôi · Nắm tay ---
        PoseLibraryItem(
          id: 'c_hold_hand_01',
          title: 'Nắm Tay Đi Dạo',
          category: 'Cặp đôi',
          context: 'Ngoài trời',
          poseType: 'Dáng đi/Chuyển động',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1474552226712-ac0f0961a954?w=600&auto=format&fit=crop&q=80',
          description:
              'Hai người nắm tay nhau và đi dạo, chụp ảnh từ phía sau hoặc từ bên cạnh. Cực kỳ tự nhiên và lãng mạn.',
          steps: [
            'Hai người đi bên nhau, nắm tay',
            'Nhiếp ảnh gia chụp từ phía sau hoặc góc 45°',
            'Bước đi thoải mái, tự nhiên',
            'Có thể nhìn vào nhau và cười',
          ],
          isNew: true,
          tips: [],
        ),

        // --- Cặp đôi · Dựa đầu ---
        PoseLibraryItem(
          id: 'c_lean_head_01',
          title: 'Dựa Đầu Vào Nhau',
          category: 'Cặp đôi',
          context: 'Cafe/Quán ăn',
          poseType: 'Dáng ngồi',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1502301103665-0b95cc738daf?w=600&auto=format&fit=crop&q=80',
          description:
              'Hai người ngồi gần nhau, dựa đầu vào nhau. Dáng này tạo cảm giác thân mật và dịu dàng, rất phù hợp với ảnh kỷ niệm tại cafe.',
          steps: [
            'Ngồi hoặc đứng gần nhau',
            'Hai người nhẹ nhàng dựa đầu vào nhau',
            'Mắt nhắm nhẹ hoặc nhìn xa xăm',
            'Có thể nắm tay hoặc ôm vai nhau',
          ],
          tips: [],
        ),

        // --- Cặp đôi · Biển ---
        PoseLibraryItem(
          id: 'c_beach_01',
          title: 'Cặp Đôi Trên Bãi Biển',
          category: 'Cặp đôi',
          context: 'Du lịch biển',
          poseType: 'Dáng đứng',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=600&auto=format&fit=crop&q=80',
          description:
              'Hai người đứng cạnh nhau trên bãi biển với sóng nước và hoàng hôn phía sau. Một trong những dáng lãng mạn nhất.',
          steps: [
            'Đứng cạnh nhau quay mặt về phía biển hoặc camera',
            'Một người đặt tay lên vai người kia',
            'Chụp lúc hoàng hôn để có ánh sáng đẹp',
            'Nhiếp ảnh gia chụp từ phía sau để có silhouette',
          ],
          isHot: true,
          isNew: true,
          tips: [
            const PoseTip(
              id: 'tip_beach_couple_a',
              category: 'Ánh sáng',
              icon: '🌅',
              title: 'Silhouette hoàng hôn',
              description:
                  'Chụp ngược sáng lúc hoàng hôn tạo ảnh silhouette cặp đôi cực kỳ ấn tượng và lãng mạn.',
            ),
          ],
        ),

        // --- Cặp đôi · Hoa ---
        PoseLibraryItem(
          id: 'c_flower_01',
          title: 'Tặng Hoa Người Thương',
          category: 'Cặp đôi',
          context: 'Ngoài trời',
          poseType: 'Phụ kiện',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=600&auto=format&fit=crop&q=80',
          description:
              'Một người tặng hoa cho người kia hoặc cả hai cùng cầm bó hoa. Tạo câu chuyện đẹp và lãng mạn trong bức ảnh.',
          steps: [
            'Chuẩn bị bó hoa tươi phù hợp màu trang phục',
            'Người tặng đưa hoa, người nhận nhìn vào hoa hoặc nhìn người tặng',
            'Chụp khoảnh khắc tự nhiên không dàn dựng',
            'Nhiếp ảnh gia chụp cả cảnh và cận mặt',
          ],
          isNew: true,
          tips: [],
        ),

        // ====================================================================
        // DANH MỤC: NHÓM
        // ====================================================================

        // --- Nhóm · Chụm đầu ---
        PoseLibraryItem(
          id: 'g_heads_together_01',
          title: 'Nhóm Chụm Đầu Lại',
          category: 'Nhóm',
          context: 'Ngoài trời',
          poseType: 'Dáng ngồi',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600&auto=format&fit=crop&q=80',
          description:
              'Cả nhóm chụm đầu vào nhau chụp từ trên xuống. Dáng luôn tạo sự vui vẻ và gắn kết nhóm.',
          steps: [
            'Cả nhóm nằm xuống đất hoặc ngồi thành vòng tròn',
            'Chụm đầu vào trung tâm vòng tròn',
            'Nhiếp ảnh gia đứng ở giữa và chụp từ trên xuống',
            'Tất cả cùng cười và nhìn lên ống kính',
          ],
          isHot: true,
          tips: [
            const PoseTip(
              id: 'tip_group_heads_a',
              category: 'Góc chụp',
              icon: '🔭',
              title: 'Chụp thẳng từ trên xuống',
              description:
                  'Người chụp đứng thẳng đứng ở giữa, giơ điện thoại lên cao nhất có thể và chụp thẳng đứng để thấy được tất cả các mặt.',
            ),
          ],
        ),

        // --- Nhóm · Bậc thang ---
        PoseLibraryItem(
          id: 'g_stair_pose_01',
          title: 'Nhóm Đứng Bậc Thang',
          category: 'Nhóm',
          context: 'Ngoài trời',
          poseType: 'Dáng đứng',
          difficulty: 'Trung bình',
          imageUrl:
              'https://images.unsplash.com/photo-1543269865-cbf427effbad?w=600&auto=format&fit=crop&q=80',
          description:
              'Sắp xếp nhóm theo độ cao khác nhau — đứng, ngồi ghế, ngồi dưới đất — tạo bố cục phân tầng đẹp mắt.',
          steps: [
            'Sắp xếp người cao đứng sau, người thấp ngồi trước',
            'Xen kẽ giữa đứng và ngồi để tránh cứng nhắc',
            'Đảm bảo mọi khuôn mặt đều nhìn thấy trong ảnh',
            'Cả nhóm cùng cười và nhìn vào ống kính',
          ],
          tips: [],
        ),

        // --- Nhóm · Nhảy ---
        PoseLibraryItem(
          id: 'g_jump_01',
          title: 'Nhóm Cùng Nhảy',
          category: 'Nhóm',
          context: 'Ngoài trời',
          poseType: 'Dáng đi/Chuyển động',
          difficulty: 'Trung bình',
          imageUrl:
              'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=600&auto=format&fit=crop&q=80',
          description:
              'Cả nhóm cùng nhảy lên vào đúng khoảnh khắc để tạo ảnh năng động và vui vẻ. Cần phối hợp tốt và chụp burst.',
          steps: [
            'Đứng thành hàng ngang hoặc hình bán nguyệt',
            'Đếm 1-2-3 rồi tất cả nhảy cùng lúc',
            'Nhiếp ảnh gia chụp ở chế độ burst',
            'Chọn khung hình đẹp nhất với tất cả trong không khí',
          ],
          isHot: true,
          isNew: true,
          tips: [],
        ),

        // --- Nhóm · Cafe ---
        PoseLibraryItem(
          id: 'g_cafe_01',
          title: 'Nhóm Bạn Tụ Tập Cafe',
          category: 'Nhóm',
          context: 'Cafe/Quán ăn',
          poseType: 'Dáng ngồi',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600&auto=format&fit=crop&q=80',
          description:
              'Cả nhóm ngồi quanh bàn cafe, cầm ly nước và cười đùa vui vẻ. Ảnh lifestyle nhóm bạn thân thiết.',
          steps: [
            'Ngồi quanh bàn cafe, sắp xếp cốc ly trên bàn',
            'Mỗi người cầm cốc hoặc để tay lên bàn tự nhiên',
            'Hướng nhìn: vào nhau, vào camera, hoặc cười với nhau',
            'Chụp từ trên cao nhìn xuống để thấy hết cả nhóm',
          ],
          isNew: true,
          tips: [
            const PoseTip(
              id: 'tip_group_cafe_a',
              category: 'Góc chụp',
              icon: '🔭',
              title: 'Flat lay nhóm bạn',
              description:
                  'Chụp từ trên cao nhìn xuống bàn để thấy tất cả các mặt người và đồ vật trên bàn — tạo ảnh nhóm độc đáo.',
            ),
          ],
        ),

        // ====================================================================
        // THÊM DÁNG ĐẶC BIỆT
        // ====================================================================

        // --- Nữ · Du lịch biển · Nhảy ---
        PoseLibraryItem(
          id: 'f_jump_beach_01',
          title: 'Nhảy Tung Bay Trên Biển',
          category: 'Nữ',
          context: 'Du lịch biển',
          poseType: 'Dáng đi/Chuyển động',
          difficulty: 'Trung bình',
          imageUrl:
              'https://images.unsplash.com/photo-1488085061387-422e29b40080?w=600&auto=format&fit=crop&q=80',
          description:
              'Nhảy cao trên bãi biển, dang rộng tay và chân tạo cảm giác bay bổng và tự do. Cực kỳ đẹp khi kết hợp với hoàng hôn biển.',
          steps: [
            'Chạy đà vài bước để nhảy cao hơn',
            'Nhảy lên và dang rộng tay hoặc thu chân lại',
            'Nhiếp ảnh gia chụp ở chế độ burst (liên tiếp)',
            'Chọn khung hình đẹp nhất sau khi xem lại',
            'Chụp ngược sáng hoàng hôn để tạo silhouette',
          ],
          isHot: true,
          tips: [],
        ),

        // --- Nữ · Du lịch · Ngồi đỉnh đồi ---
        PoseLibraryItem(
          id: 'f_sit_hilltop_01',
          title: 'Ngồi Trên Đỉnh Đồi',
          category: 'Nữ',
          context: 'Ngoài trời',
          poseType: 'Dáng ngồi',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&auto=format&fit=crop&q=80',
          description:
              'Ngồi trên đỉnh đồi hoặc vách đá nhìn ra xa, chụp từ phía sau để kết hợp vóc dáng với phong cảnh hùng vĩ.',
          steps: [
            'Ngồi trên mỏm đá hoặc đỉnh đồi',
            'Nhìn ra xa về phía đường chân trời',
            'Nhiếp ảnh gia chụp từ phía sau hoặc từ bên',
            'Dang tay ra rộng hoặc ôm gối tùy phong cách',
          ],
          isNew: true,
          tips: [],
        ),

        // --- Nữ · Hoa che nửa mặt ---
        PoseLibraryItem(
          id: 'f_flower_face_01',
          title: 'Hoa Che Nửa Mặt',
          category: 'Nữ',
          context: 'Ngoài trời',
          poseType: 'Phụ kiện',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?w=600&auto=format&fit=crop&q=80',
          description:
              'Dùng hoa, lá cây hoặc cành cây che nhẹ một phần khuôn mặt. Tạo khung tự nhiên thơ mộng cho ảnh chân dung ngoài trời.',
          steps: [
            'Cầm một bó hoa hoặc cành lá nhỏ',
            'Nâng lên che khoảng 1/4 khuôn mặt',
            'Nhìn qua hoặc nhìn ra ngoài bông hoa',
            'Nhiếp ảnh gia focus vào mắt, để hoa hơi blur nhẹ',
          ],
          isHot: true,
          isNew: true,
          tips: [],
        ),

        // --- Nam · Studio · Editorial ---
        PoseLibraryItem(
          id: 'm_studio_editorial_01',
          title: 'Dáng Thời Trang Editorial Nam',
          category: 'Nam',
          context: 'Studio',
          poseType: 'Dáng đứng',
          difficulty: 'Khó',
          imageUrl:
              'https://images.unsplash.com/photo-1488161628813-04466f872be2?w=600&auto=format&fit=crop&q=80',
          description:
              'Dáng mạnh mẽ, góc cạnh với các đường thẳng của cơ thể tạo hình ảnh thời trang cao cấp. Thường thấy trên tạp chí Vogue, GQ.',
          steps: [
            'Đứng thẳng, vai vuông góc hoàn toàn với máy ảnh',
            'Tay đặt trên hông hoặc dang ra ngang thân',
            'Chân đứng thẳng hoặc bước một chân lên trước',
            'Biểu cảm lạnh lùng, tự tin — "fierce look"',
            'Tập trước gương để cảm nhận đường cơ thể',
          ],
          tips: [],
        ),

        // --- Nữ · Studio · Nằm sàn ---
        PoseLibraryItem(
          id: 'f_floor_studio_01',
          title: 'Nằm Trên Sàn Studio',
          category: 'Nữ',
          context: 'Studio',
          poseType: 'Dáng ngồi',
          difficulty: 'Trung bình',
          imageUrl:
              'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=600&auto=format&fit=crop&q=80',
          description:
              'Nằm trên sàn studio hoặc thảm, tạo góc chụp độc đáo từ trên xuống (flat lay portrait). Rất sáng tạo và khác biệt.',
          steps: [
            'Nằm ngửa hoặc nghiêng trên nền sàn sạch',
            'Sắp xếp tóc và quần áo gọn gàng',
            'Nhiếp ảnh gia chụp từ trên cao nhìn xuống',
            'Tạo biểu cảm đa dạng — cười, nhìn xa, nhắm mắt',
          ],
          isNew: true,
          tips: [],
        ),

        // --- Nữ · Công sở · Cầm cốc cafe ---
        PoseLibraryItem(
          id: 'f_office_coffee_01',
          title: 'Cầm Cốc Cafe Phong Cách',
          category: 'Nữ',
          context: 'Cafe/Quán ăn',
          poseType: 'Phụ kiện',
          difficulty: 'Dễ',
          imageUrl:
              'https://images.unsplash.com/photo-1554188248-986adbb73be4?w=600&auto=format&fit=crop&q=80',
          description:
              'Cầm cốc cafe takeaway hoặc cốc dẹp trên đường đi làm. Tạo cảm giác thời thượng và năng động cho ảnh lifestyle sáng sớm.',
          steps: [
            'Cầm cốc cafe bằng hai tay hoặc một tay',
            'Đứng hoặc đi trên đường, nhìn vào cốc hoặc nhìn sang ngang',
            'Mặc trang phục công sở hoặc casual chic',
            'Chụp trong ánh sáng buổi sáng tự nhiên',
          ],
          isHot: true,
          tips: [
            const PoseTip(
              id: 'tip_coffee_a',
              category: 'Trang phục',
              icon: '☕',
              title: 'Màu cốc phù hợp trang phục',
              description:
                  'Chọn cốc cafe có màu sắc hoặc họa tiết đẹp, phù hợp với trang phục để tạo tổng thể hài hòa trong ảnh.',
            ),
          ],
        ),
      ];
}
