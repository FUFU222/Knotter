import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(privacyText)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(6)
                }
                .padding(AppTheme.spacing)
            }
        }
        .navigationTitle(String(localized: "legal_privacy"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var isJapanese: Bool {
        Locale.current.language.languageCode?.identifier == "ja"
    }

    private var privacyText: String {
        isJapanese ? privacyTextJA : privacyTextEN
    }

    private var privacyTextJA: String {
        """
        Knotter プライバシーポリシー

        最終更新日: 2026年3月21日

        Knotter（以下「本アプリ」）は、ユーザーのプライバシーを尊重し、個人情報の保護に努めます。本プライバシーポリシー（以下「本ポリシー」）は、本アプリにおける個人情報の取り扱いについて説明するものです。

        1. 収集する情報

        本アプリでは、以下の情報を収集します。

        (1) ユーザーが提供する情報
        ・メールアドレス（アカウント登録・ログインに使用）
        ・ユーザー名、表示名
        ・プロフィール情報（自己紹介文）
        ・プロフィール画像（アバター）
        ・投稿コンテンツ（画像、動画、キャプション）
        ・コメント内容

        (2) 自動的に収集される情報
        ・アカウント作成日時、更新日時
        ・いいね、フォロー等のアクション履歴
        ・通知履歴（いいね、コメント、フォローに関する通知）

        (3) 収集しない情報
        本アプリでは以下の情報は収集しません。
        ・位置情報
        ・連絡先情報
        ・健康データ
        ・決済情報
        ・デバイスの識別子（広告ID等）

        2. 情報の利用目的

        収集した情報は、以下の目的で利用します。
        ・アカウントの作成・認証・管理
        ・投稿、コメント、いいね等のSNS機能の提供
        ・フォロー機能およびユーザー検索機能の提供
        ・通知機能の提供
        ・プロフィールの表示・編集機能の提供
        ・サービスの改善・品質向上
        ・不正利用の防止

        3. 情報の保存と管理

        ・ユーザーの情報は、Supabase（クラウドサービス）のサーバーに保存されます。
        ・サーバーはAWSインフラストラクチャ上で運用されており、データは暗号化された通信（HTTPS/TLS）を通じて送受信されます。
        ・画像・動画ファイルは、Supabase Storageに保存されます。
        ・パスワードはSupabase Authにより安全にハッシュ化されて保存されます。

        4. 情報の第三者提供

        本アプリでは、以下の場合を除き、ユーザーの個人情報を第三者に提供しません。
        ・ユーザーの同意がある場合
        ・法令に基づく場合
        ・人の生命、身体または財産の保護のために必要がある場合
        ・サービス提供に必要な業務委託先に対して（Supabase等のインフラサービス）

        5. 公開される情報

        以下の情報は、他のユーザーに公開されます。
        ・ユーザー名、表示名
        ・プロフィール画像
        ・自己紹介文
        ・投稿コンテンツ（画像、動画、キャプション）
        ・コメント内容
        ・いいね数
        ・フォロワー数、フォロー数

        6. 写真ライブラリへのアクセス

        本アプリは、投稿作成およびプロフィール画像の設定のために、ユーザーの写真ライブラリへのアクセスを要求します。アクセスはユーザーが選択した画像・動画のみに限定され、写真ライブラリ全体を閲覧・収集することはありません。

        7. ユーザーの権利

        ユーザーは以下の権利を有します。
        ・自身のプロフィール情報の閲覧・編集
        ・投稿したコンテンツの削除
        ・アカウントの削除の申請
        ・個人情報の開示・訂正・削除の請求

        8. 未成年者の利用

        本アプリは13歳未満の方の利用を想定しておりません。13歳未満の方が個人情報を提供したことが判明した場合、速やかに当該情報を削除します。

        9. Cookieおよびトラッキング

        本アプリはネイティブiOSアプリであり、Cookieは使用しません。また、第三者のトラッキングツールや広告SDKは組み込んでおりません。

        10. データの保持期間

        ・アカウントが有効な間、ユーザーの情報を保持します。
        ・アカウント削除の申請があった場合、合理的な期間内にデータを削除します。
        ・法令により保持が義務付けられる情報については、必要な期間保持します。

        11. セキュリティ

        本アプリでは、ユーザーの情報を保護するため、以下のセキュリティ対策を実施しています。
        ・通信の暗号化（HTTPS/TLS）
        ・パスワードのハッシュ化
        ・認証トークンによるアクセス制御
        ・Supabaseのセキュリティ機能の活用

        ただし、インターネット上の通信において完全なセキュリティを保証することはできません。

        12. ポリシーの変更

        本ポリシーは、必要に応じて変更されることがあります。重要な変更がある場合は、本アプリ内で通知します。変更後も本アプリの利用を継続した場合、変更後のポリシーに同意したものとみなします。

        13. お問い合わせ

        個人情報の取り扱いに関するお問い合わせは、アプリ内のお問い合わせ機能またはメールにてご連絡ください。
        """
    }

    private var privacyTextEN: String {
        """
        Knotter Privacy Policy

        Last Updated: March 21, 2026

        Knotter (hereinafter referred to as "the App") respects User privacy and is committed to protecting personal information. This Privacy Policy (hereinafter referred to as "the Policy") explains how personal information is handled within the App.

        1. Information We Collect

        The App collects the following information:

        (1) Information Provided by Users
        - Email address (used for account registration and login)
        - Username, display name
        - Profile information (biography)
        - Profile image (avatar)
        - Posted Content (images, videos, captions)
        - Comments

        (2) Information Collected Automatically
        - Account creation and update timestamps
        - Action history such as likes and follows
        - Notification history (notifications related to likes, comments, and follows)

        (3) Information We Do Not Collect
        The App does not collect the following information:
        - Location data
        - Contact information
        - Health data
        - Payment information
        - Device identifiers (advertising IDs, etc.)

        2. Purpose of Use

        Collected information is used for the following purposes:
        - Account creation, authentication, and management
        - Providing social networking features such as posts, comments, and likes
        - Providing follow and user search functionality
        - Providing notification functionality
        - Providing profile display and editing functionality
        - Service improvement and quality enhancement
        - Prevention of unauthorized use

        3. Data Storage and Management

        - User information is stored on Supabase (cloud service) servers.
        - Servers operate on AWS infrastructure, and data is transmitted through encrypted communications (HTTPS/TLS).
        - Image and video files are stored in Supabase Storage.
        - Passwords are securely hashed and stored by Supabase Auth.

        4. Disclosure of Information to Third Parties

        The App does not provide Users' personal information to third parties except in the following cases:
        - When the User has given consent
        - When required by law
        - When necessary to protect the life, body, or property of an individual
        - To subcontractors necessary for service provision (infrastructure services such as Supabase)

        5. Publicly Visible Information

        The following information is visible to other Users:
        - Username, display name
        - Profile image
        - Biography
        - Posted Content (images, videos, captions)
        - Comments
        - Number of likes
        - Follower count, following count

        6. Access to Photo Library

        The App requests access to the User's photo library for creating posts and setting profile images. Access is limited to images and videos selected by the User; the App does not browse or collect the entire photo library.

        7. User Rights

        Users have the following rights:
        - Viewing and editing their own profile information
        - Deleting their posted Content
        - Requesting deletion of their account
        - Requesting disclosure, correction, or deletion of their personal information

        8. Use by Minors

        The App is not intended for use by individuals under the age of 13. If we become aware that a person under the age of 13 has provided personal information, we will promptly delete such information.

        9. Cookies and Tracking

        The App is a native iOS application and does not use cookies. Additionally, no third-party tracking tools or advertising SDKs are integrated.

        10. Data Retention Period

        - User information is retained while the account remains active.
        - Upon request for account deletion, data will be deleted within a reasonable period.
        - Information required to be retained by law will be kept for the necessary duration.

        11. Security

        The App implements the following security measures to protect User information:
        - Encryption of communications (HTTPS/TLS)
        - Password hashing
        - Access control via authentication tokens
        - Utilization of Supabase security features

        However, we cannot guarantee complete security for communications over the Internet.

        12. Changes to the Policy

        The Policy may be amended as necessary. In the event of significant changes, Users will be notified within the App. Continued use of the App after any changes shall be deemed as acceptance of the revised Policy.

        13. Contact Information

        For inquiries regarding the handling of personal information, please contact us through the in-app contact feature or by email.
        """
    }
}
