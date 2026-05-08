export function focusRef(ref) {
  // ref?.current?.focus()
  const target = ref?.current ?? ref
  target?.focus?.()
}

export function moveIndex(currentIndex, step, maxIndex) {
  const safeCurrentIndex = currentIndex < 0 ? 0 : currentIndex
  return Math.max(0, Math.min(safeCurrentIndex + step, maxIndex))
}

export function moveFocusByOffset(refs, currentRef, offset) {
  const currentIndex = refs.findIndex((ref) => ref === currentRef)
  if (currentIndex < 0) return

  const nextIndex = currentIndex + offset
  if (nextIndex < 0 || nextIndex >= refs.length) return

  focusRef(refs[nextIndex])
}

export function ensureVisibleInScrollArea({
  container,
  target,
  headerSelector = "thead",
  padding = 8,
  includeHorizontal = false,
}) {
  if (!container || !target) return

  const containerRect = container.getBoundingClientRect()
  const targetRect = target.getBoundingClientRect()
  const headerHeight = container.querySelector(headerSelector)?.getBoundingClientRect().height ?? 42
  const topLimit = containerRect.top + headerHeight
  const bottomLimit = containerRect.bottom

  if (targetRect.top < topLimit) {
    container.scrollTop -= topLimit - targetRect.top + padding
  } else if (targetRect.bottom > bottomLimit) {
    container.scrollTop += targetRect.bottom - bottomLimit + padding
  }

  if (!includeHorizontal) return

  if (targetRect.left < containerRect.left) {
    container.scrollLeft -= containerRect.left - targetRect.left + padding
  } else if (targetRect.right > containerRect.right) {
    container.scrollLeft += targetRect.right - containerRect.right + padding
  }
}
