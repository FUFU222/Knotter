import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(termsText)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(6)
                }
                .padding(AppTheme.spacing)
            }
        }
        .navigationTitle(String(localized: "legal_terms"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var isJapanese: Bool {
        Locale.current.language.languageCode?.identifier == "ja"
    }

    private var termsText: String {
        isJapanese ? termsTextJA : termsTextEN
    }

    private var termsTextJA: String {
        """
        Knotter 利用規約

        最終更新日: 2026年3月21日

        本利用規約（以下「本規約」）は、Knotter（以下「本アプリ」）の利用に関する条件を定めるものです。本アプリをご利用いただく前に、本規約をよくお読みください。本アプリを利用することにより、本規約に同意したものとみなされます。

        第1条（定義）
        1. 「ユーザー」とは、本アプリを利用する全ての方をいいます。
        2. 「コンテンツ」とは、ユーザーが本アプリに投稿する画像、動画、テキスト等の情報をいいます。
        3. 「本サービス」とは、本アプリを通じて提供される全てのサービスをいいます。

        第2条（アカウント登録）
        1. 本サービスの利用にはアカウント登録が必要です。
        2. ユーザーは、正確かつ最新の情報を登録する必要があります。
        3. アカウントの管理はユーザー自身の責任で行うものとし、第三者への譲渡・貸与はできません。
        4. パスワードの管理はユーザーの責任とし、不正利用による損害について当社は責任を負いません。

        第3条（禁止事項）
        ユーザーは、本サービスの利用にあたり、以下の行為を行ってはなりません。
        1. 法令または公序良俗に反する行為
        2. 犯罪行為に関連する行為
        3. 他のユーザーまたは第三者の知的財産権、肖像権、プライバシー、名誉その他の権利を侵害する行為
        4. 他のユーザーに対する嫌がらせ、誹謗中傷、脅迫行為
        5. わいせつ、暴力的、差別的なコンテンツの投稿
        6. 虚偽の情報を流布する行為
        7. 本サービスの運営を妨害する行為
        8. 不正アクセスまたはこれを試みる行為
        9. 他のユーザーの個人情報を無断で収集・利用する行為
        10. 結び目の技術に関して、安全性を欠く危険な使用方法を推奨する行為
        11. 商業目的での無断利用（広告、勧誘等）
        12. その他、運営者が不適切と判断する行為

        第4条（コンテンツに関する権利）
        1. ユーザーが投稿したコンテンツの著作権はユーザーに帰属します。
        2. ユーザーは、本アプリへのコンテンツ投稿により、当社に対してコンテンツを本サービスの提供・改善・宣伝の目的で使用する非独占的なライセンスを付与するものとします。
        3. 当社は、法令に基づく場合、または本規約に違反するコンテンツについて、事前通知なく削除する権利を有します。

        第5条（サービスの変更・中断・終了）
        1. 当社は、ユーザーへの事前通知なく、本サービスの内容を変更、中断、または終了することができます。
        2. 本サービスの変更、中断、終了によりユーザーに生じた損害について、当社は責任を負いません。

        第6条（免責事項）
        1. 当社は、本サービスの内容、正確性、信頼性、利用可能性について、いかなる保証も行いません。
        2. ユーザー間のトラブルについて、当社は一切の責任を負いません。
        3. 本サービスの利用により生じた損害（データの喪失を含む）について、当社の故意または重大な過失がない限り、責任を負いません。
        4. 結び目の技術に関するコンテンツは参考情報であり、実際の使用においてはユーザー自身の判断と責任で行うものとします。

        第7条（アカウントの停止・削除）
        1. 当社は、ユーザーが本規約に違反した場合、事前通知なくアカウントを停止または削除できます。
        2. ユーザーは、いつでもアカウントの削除を申請できます。

        第8条（規約の変更）
        1. 当社は、必要に応じて本規約を変更できるものとします。
        2. 変更後の規約は、本アプリ内での表示をもって効力を生じるものとします。
        3. 変更後も本サービスの利用を継続した場合、変更後の規約に同意したものとみなします。

        第9条（準拠法・管轄）
        1. 本規約は日本法に準拠します。
        2. 本規約に関する紛争は、東京地方裁判所を第一審の専属的合意管轄裁判所とします。

        第10条（お問い合わせ）
        本規約に関するお問い合わせは、アプリ内のお問い合わせ機能またはメールにてご連絡ください。
        """
    }

    private var termsTextEN: String {
        """
        Knotter Terms of Service

        Last Updated: March 21, 2026

        These Terms of Service (hereinafter referred to as "Terms") set forth the conditions governing the use of Knotter (hereinafter referred to as "the App"). Please read these Terms carefully before using the App. By using the App, you are deemed to have agreed to these Terms.

        Article 1 (Definitions)
        1. "User" refers to any individual who uses the App.
        2. "Content" refers to images, videos, text, and other information posted by Users on the App.
        3. "Service" refers to all services provided through the App.

        Article 2 (Account Registration)
        1. Account registration is required to use the Service.
        2. Users must register accurate and up-to-date information.
        3. Users are responsible for managing their own accounts and may not transfer or lend their accounts to third parties.
        4. Users are responsible for managing their passwords. We shall not be liable for any damages resulting from unauthorized use.

        Article 3 (Prohibited Activities)
        Users shall not engage in any of the following activities when using the Service:
        1. Activities that violate laws, regulations, or public order and morals
        2. Activities related to criminal conduct
        3. Activities that infringe upon the intellectual property rights, portrait rights, privacy, reputation, or other rights of other Users or third parties
        4. Harassment, defamation, or threats directed at other Users
        5. Posting obscene, violent, or discriminatory Content
        6. Disseminating false information
        7. Activities that interfere with the operation of the Service
        8. Unauthorized access or attempts thereof
        9. Collecting or using other Users' personal information without consent
        10. Promoting unsafe or dangerous methods of use regarding knot-tying techniques
        11. Unauthorized commercial use (advertising, solicitation, etc.)
        12. Any other activities deemed inappropriate by the operator

        Article 4 (Rights Regarding Content)
        1. Copyright of Content posted by Users belongs to the respective Users.
        2. By posting Content on the App, Users grant us a non-exclusive license to use such Content for the purposes of providing, improving, and promoting the Service.
        3. We reserve the right to remove, without prior notice, any Content that violates applicable laws or these Terms.

        Article 5 (Modification, Suspension, or Termination of the Service)
        1. We may modify, suspend, or terminate the Service without prior notice to Users.
        2. We shall not be liable for any damages incurred by Users as a result of any modification, suspension, or termination of the Service.

        Article 6 (Disclaimer)
        1. We make no warranties regarding the content, accuracy, reliability, or availability of the Service.
        2. We shall bear no responsibility for any disputes between Users.
        3. We shall not be liable for any damages (including loss of data) arising from the use of the Service, except in cases of our willful misconduct or gross negligence.
        4. Content related to knot-tying techniques is provided for informational purposes only. Users shall exercise their own judgment and assume their own responsibility when applying such techniques in practice.

        Article 7 (Account Suspension or Deletion)
        1. We may suspend or delete a User's account without prior notice if the User violates these Terms.
        2. Users may request the deletion of their account at any time.

        Article 8 (Amendments to the Terms)
        1. We may amend these Terms as necessary.
        2. Amended Terms shall take effect upon being displayed within the App.
        3. Continued use of the Service after any amendment shall be deemed as acceptance of the amended Terms.

        Article 9 (Governing Law and Jurisdiction)
        1. These Terms shall be governed by the laws of Japan.
        2. Any disputes arising in connection with these Terms shall be subject to the exclusive jurisdiction of the Tokyo District Court as the court of first instance.

        Article 10 (Contact Information)
        For inquiries regarding these Terms, please contact us through the in-app contact feature or by email.
        """
    }
}
