import SwiftUI
import UIKit

@MainActor
struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var model = CameraModel()
    let onPhoto: (Data) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if model.photoData == nil{
                    topBar
                }
                
                viewfinder
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if model.photoData == nil{
                    bottomBar
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(.black)
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
        .statusBarHidden()
        .onAppear { model.appear(isActive: scenePhase == .active) }
        .onDisappear { model.disappear() }
        .onChange(of: scenePhase) { _, phase in model.setActive(phase == .active) }
        .alert("Câmera", isPresented: Binding(
            get: { model.errorMessage != nil },
            set: { if !$0 { model.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { model.errorMessage = nil }
        } message: { Text(model.errorMessage ?? "") }
            .toolbar {
                if let data = model.photoData {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(role: .cancel) {
                            model.retake()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .confirm) {
                            onPhoto(data)
                            dismiss()
                        }
                        .fontWeight(.semibold)
                        .tint(.green500)
                    }
                }
            }
            .navigationBarBackButtonHidden(model.photoData != nil)
        
    }
    
    private var topBar: some View {
        HStack {
            Spacer()
            Button(action: {
                model.flash.toggle()
            }, label: {
                Image(systemName: model.flash.icon)
                    .foregroundStyle(model.flash == .off ? .white : .yellow)
            })
            .buttonStyle(.glassProminent)
            .tint(.clear)
            .disabled(!model.state.supportsFlash || !model.canTakePhoto)
            .opacity(model.state.supportsFlash && model.photoData == nil ? 1 : 0)
            .accessibilityLabel("Flash: \(model.flash.title)")
        }
        .opacity(model.state.supportsFlash && model.photoData == nil ? 1 : 0)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder private var viewfinder: some View {
        if let image = model.photoImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .accessibilityLabel("Foto capturada")
        } else if model.accessDenied {
            ContentUnavailableView {
                Label("Permita o acesso à câmera", systemImage: "camera.fill")
            } description: {
                Text("Ative a permissão de câmera nos Ajustes para tirar uma foto.")
            } actions: {
                Button("Abrir Ajustes") {
                    if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
                }
            }
        } else {
            CameraPreview(
                session: model.session,
                isFront: model.state.isFront,
                zoom: model.state.zoom,
                onFocus: {
                    model.focus(at: $0)
                },
                onZoom: {
                    model.setZoom($0, animated: false)
                },
                onRotation: {
                    model.rotationAngle = $0
                }
            )
            .overlay {
                if model.isStarting {
                    ProgressView("Abrindo câmera…")
                } else if !model.state.isRunning && !model.state.isCapturing {
                    Button("Tentar novamente") { model.start() }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    @ViewBuilder private var bottomBar: some View {
        VStack(spacing: 18) {
            
            //Parte do zoom, caso for implementado depois
            HStack(spacing: 12) {
                let zoom = model.displayedZoom
                
                let activeFactor = model.zoomPresets.last {
                    $0 <= zoom
                } ?? model.zoomPresets.first ?? 1
                
                ForEach(model.zoomPresets, id: \.self) { factor in
                    let isActive = factor == activeFactor
                    
                    Button {
                        model.setZoom(factor)
                    } label: {
                        Text(
                            isActive
                            ? "\(zoom.formatted(.number.precision(.fractionLength(0...1))))×"
                            : "\(factor.formatted(.number.precision(.fractionLength(0...1))))×"
                        )
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(isActive ? .yellow : .white)
                        .frame(width: 44, height: 44)
                        .background(
                            .white.opacity(0.12),
                            in: Circle()
                        )
                    }
                    .accessibilityLabel("Selecionar zoom \(factor) vezes")
                }
            }
            .disabled(!model.canTakePhoto)
            
            HStack {
                Color.clear.frame(width: 52, height: 52)
                Spacer()
                Button {
                    model.takePhoto()
                } label: {
                    ZStack {
                        Circle().stroke(.white, lineWidth: 4).frame(width: 76, height: 76)
                        Circle().fill(.white).frame(width: 64, height: 64)
                    }
                }
                .disabled(!model.canTakePhoto)
                .opacity(model.canTakePhoto || model.state.isCapturing ? 1 : 0.4)
                .accessibilityLabel("Tirar foto")
                Spacer()
                Button { model.switchCamera() } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .font(.title2)
                        .frame(width: 52, height: 52)
                        .background(.white.opacity(0.12), in: Circle())
                }
                .disabled(!model.canTakePhoto || !model.state.canSwitchCamera)
                .accessibilityLabel("Alternar câmera frontal e traseira")
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 12)
        
    }
}
