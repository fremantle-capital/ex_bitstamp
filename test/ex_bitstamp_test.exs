defmodule ExBitstampTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBitstamp

  setup_all do
    HTTPoison.start
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
  end

  test "order_book returns a list of bids & asks for the currency pair" do
    use_cassette "order_book_success" do
      {:ok, order_book} = ExBitstamp.order_book(:btcusd)

      assert order_book == %{
        "timestamp" => "1513896396",
        "bids" => [
          ["15677.95", "0.15180556"],
          ["15677.94", "1.49272243"],
          ["15677.75", "0.27232000"],
          ["15677.74", "12.52500000"],
          ["15672.29", "0.00319470"]
        ],
        "asks" => [
          ["15730.00", "0.27969236"],
          ["15734.78", "0.26145000"],
          ["15734.80", "0.95060000"],
          ["15735.00", "1.70000000"],
          ["15739.95", "0.00251380"]
        ]
      }
    end
  end

  test "order_book supports strings and downcases the given symbol" do
    use_cassette "order_book_success" do
      {:ok, order_book} = ExBitstamp.order_book("BTCUSD")

      assert order_book == %{
        "timestamp" => "1513896396",
        "bids" => [
          ["15677.95", "0.15180556"],
          ["15677.94", "1.49272243"],
          ["15677.75", "0.27232000"],
          ["15677.74", "12.52500000"],
          ["15672.29", "0.00319470"]
        ],
        "asks" => [
          ["15730.00", "0.27969236"],
          ["15734.78", "0.26145000"],
          ["15734.80", "0.95060000"],
          ["15735.00", "1.70000000"],
          ["15739.95", "0.00251380"]
        ]
      }
    end
  end

  test "order_book returns an error/message tuple when the symbol does not exist" do
    use_cassette "order_book_error" do
      assert ExBitstamp.order_book(:IDONTEXIST) == {:error, "not found"}
    end
  end

  test "balance returns the value of each account" do
    use_cassette "balance_success" do
      {:ok, balances} = ExBitstamp.balance

      assert balances["usd_balance"] == "0.00"
      assert balances["usd_available"] == "0.00"
      assert balances["usd_reserved"] == "0.00"
      assert balances["btc_balance"] == "0.00000000"
      assert balances["btc_available"] == "0.00000000"
      assert balances["btc_reserved"] == "0.00000000"
      assert balances["btcusd_fee"] == "0.20"
      assert balances["btceur_fee"] == "0.20"
      assert balances["ltc_balance"] == "0.00000000"
      assert balances["ltc_available"] == "0.00000000"
      assert balances["ltc_reserved"] == "0.00000000"
      assert balances["ltcusd_fee"] == "0.20"
      assert balances["ltceur_fee"] == "0.20"
      assert balances["ltcbtc_fee"] == "0.20"
    end
  end

  test "balance returns an error/message tuple when the api credentials are invalid" do
    use_cassette "balance_forbidden" do
      assert ExBitstamp.balance == {:error, "Missing key, signature and nonce parameters. code: API0000"}
    end
  end

  test "ticker returns pricing data for the currency pair" do
    use_cassette "ticker_success" do
      assert ExBitstamp.ticker(:btcusd) == {:ok, %{
        "ask" => "15206.12",
        "bid" => "15200.04",
        "high" => "16480.52",
        "last" => "15200.00",
        "low" => "14484.00",
        "open" => "15390.05",
        "timestamp" => "1514422945",
        "volume" => "15637.34379848",
        "vwap" => "15448.06"
      }}
    end
  end

  test "ticker returns an error/message tuple when the currency pair doesn't exist" do
    use_cassette "ticker_not_found" do
      assert ExBitstamp.ticker(:idontexist) == {:error, "not found"}
    end
  end

  test "buy_limit creates an order and returns it's details" do
    use_cassette "buy_limit_success" do
      assert ExBitstamp.buy_limit(:btcusd, 101.1, 0.1) == {
        :ok,
        %{
          "amount" => "0.10000000",
          "datetime" => "2017-12-28 06:54:55.982660",
          "id" => "674783313",
          "price" => "101.10",
          "type" => "0"
        }
      }
    end
  end

  test "buy_limit returns an error/details tuple when it can't create the order" do
    use_cassette "buy_limit_error" do
      assert ExBitstamp.buy_limit(:btcusd, -101.1, 0.01) == {
        :error,
        %{
          "__all__" => [""],
          "price" => ["Ensure this value is greater than or equal to 1E-8."]
        }
      }
    end
  end
end
