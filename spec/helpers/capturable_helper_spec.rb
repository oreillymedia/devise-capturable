require 'spec_helper'

describe CapturableHelper, type: :helper do
  describe 'janrain_css_url' do
    context 'when not overridden' do
      it 'returns a default URL' do
        expect(helper.janrain_css_url).to eq \
          '["//cdn.oreillystatic.com/members/css/janrain.min.css"]'
      end
    end

    context 'when overridden' do
      it 'returns the overriding URL' do
        Devise.janrain_css_url = '//example.com/sample.css'
        expect(helper.janrain_css_url).to eq \
          '["//example.com/sample.css"]'
      end

      it 'accepts multiple URLs, delimited by spaces' do
        Devise.janrain_css_url = \
          '//example.com/one.css //example.com/two.css'
        expect(helper.janrain_css_url).to eq \
          '["//example.com/one.css","//example.com/two.css"]'
      end
    end
  end

  describe 'janrain_mobile_css_url' do
    context 'when not overridden' do
      it 'returns a default URL' do
        expect(helper.janrain_mobile_css_url).to eq \
          '["//cdn.oreillystatic.com/members/css/janrain-mobile.min.css"]'
      end
    end

    context 'when overridden' do
      it 'returns the overriding URL' do
        Devise.janrain_mobile_css_url = '//example.com/sample.css'
        expect(helper.janrain_mobile_css_url).to eq \
          '["//example.com/sample.css"]'
      end

      it 'accepts multiple URLs, delimited by spaces' do
        Devise.janrain_mobile_css_url = \
          '//example.com/one.css //example.com/two.css'
        expect(helper.janrain_mobile_css_url).to eq \
          '["//example.com/one.css","//example.com/two.css"]'
      end
    end
  end

  describe 'janrain_widget_url' do
    context 'when not overridden' do
      it 'returns a default URL' do
        expect(helper.janrain_widget_url).to eq \
          '//cdn.oreillystatic.com/members/js/widgets/login-widget.min.js'
      end
    end

    context 'when overridden' do
      it 'returns the overriding URL' do
        Devise.janrain_widget_url = '//example.com/widget.js'
        expect(helper.janrain_widget_url).to eq '//example.com/widget.js'
      end
    end
  end
end
